import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/bluetooth_device.dart';
import '../models/bag_status.dart';

class BluetoothService extends ChangeNotifier {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  BluetoothDeviceModel? _connectedDevice;
  
  bool _isEnabled = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isScanning = false;
  
  final List<BluetoothDeviceModel> _discoveredDevices = [];
  final List<BluetoothDeviceModel> _bondedDevices = [];
  
  StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;
  StreamSubscription? _connectionSubscription;
  Timer? _statusTimer;
  
  BagStatus _currentStatus = BagStatus(
    batteryLevel: 0,
    temperature: 0.0,
    rainLevel: 'none',
    umbrellaOpen: false,
    isConnected: false,
    lastUpdated: DateTime.now(),
  );

  // Getters
  bool get isEnabled => _isEnabled;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  BluetoothDeviceModel? get connectedDevice => _connectedDevice;
  List<BluetoothDeviceModel> get discoveredDevices => _discoveredDevices;
  List<BluetoothDeviceModel> get bondedDevices => _bondedDevices;
  BagStatus get currentStatus => _currentStatus;

  BluetoothService() {
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    try {
      // Check if Bluetooth is enabled
      _isEnabled = await _bluetooth.isEnabled ?? false;
      
      // Get bonded devices
      await _getBondedDevices();
      
      // Listen to Bluetooth state changes
      _bluetooth.onStateChanged().listen((BluetoothState state) {
        _isEnabled = state == BluetoothState.STATE_ON;
        if (!_isEnabled && _isConnected) {
          _disconnect();
        }
        notifyListeners();
      });
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing Bluetooth: $e');
    }
  }

  Future<bool> enableBluetooth() async {
    try {
      if (!_isEnabled) {
        await _bluetooth.requestEnable();
        _isEnabled = await _bluetooth.isEnabled ?? false;
        if (_isEnabled) {
          await _getBondedDevices();
        }
        notifyListeners();
      }
      return _isEnabled;
    } catch (e) {
      debugPrint('Error enabling Bluetooth: $e');
      return false;
    }
  }

  Future<void> _getBondedDevices() async {
    try {
      List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
      _bondedDevices.clear();
      _bondedDevices.addAll(devices.map((device) => BluetoothDeviceModel(
        name: device.name ?? 'Unknown Device',
        address: device.address,
        isBonded: true,
      )).toList());
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting bonded devices: $e');
    }
  }

  Future<void> startDiscovery() async {
    if (!_isEnabled || _isScanning) return;

    try {
      _isScanning = true;
      _discoveredDevices.clear();
      notifyListeners();

      _discoverySubscription = _bluetooth.startDiscovery().listen(
        (BluetoothDiscoveryResult result) {
          final device = BluetoothDeviceModel(
            name: result.device.name ?? 'Unknown Device',
            address: result.device.address,
            rssi: result.rssi,
            lastSeen: DateTime.now(),
          );
          
          // Add device if not already discovered
          if (!_discoveredDevices.any((d) => d.address == device.address)) {
            _discoveredDevices.add(device);
            notifyListeners();
          }
        },
        onDone: () {
          _isScanning = false;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Discovery error: $error');
          _isScanning = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error starting discovery: $e');
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopDiscovery() async {
    if (_isScanning) {
      await _bluetooth.cancelDiscovery();
      await _discoverySubscription?.cancel();
      _discoverySubscription = null;
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<bool> connectToDevice(BluetoothDeviceModel device) async {
    if (_isConnecting || _isConnected) return false;

    try {
      _isConnecting = true;
      notifyListeners();

      _connection = await BluetoothConnection.toAddress(device.address);
      _connectedDevice = device;
      _isConnected = true;
      _isConnecting = false;

      // Listen to incoming data
      _connectionSubscription = _connection!.input!.listen(
        _handleIncomingData,
        onDone: () {
          _disconnect();
        },
        onError: (error) {
          debugPrint('Connection error: $error');
          _disconnect();
        },
      );

      // Start periodic status updates
      _startStatusUpdates();

      // Update connection status
      _currentStatus = _currentStatus.copyWith(
        isConnected: true,
        lastUpdated: DateTime.now(),
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      _isConnecting = false;
      _isConnected = false;
      _connectedDevice = null;
      notifyListeners();
      return false;
    }
  }

  void _disconnect() {
    _connection?.close();
    _connection = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _statusTimer?.cancel();
    _statusTimer = null;
    
    _isConnected = false;
    _isConnecting = false;
    _connectedDevice = null;
    
    _currentStatus = _currentStatus.copyWith(
      isConnected: false,
      lastUpdated: DateTime.now(),
    );
    
    notifyListeners();
  }

  Future<void> disconnect() async {
    _disconnect();
  }

  void _startStatusUpdates() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isConnected) {
        _sendCommand('GET_STATUS');
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendCommand(String command) async {
    if (!_isConnected || _connection == null) return;

    try {
      final data = utf8.encode('$command\n');
      _connection!.output.add(data);
      await _connection!.output.allSent;
    } catch (e) {
      debugPrint('Error sending command: $e');
    }
  }

  void _handleIncomingData(Uint8List data) {
    try {
      final message = utf8.decode(data).trim();
      final parts = message.split(':');
      
      if (parts.length >= 2) {
        final command = parts[0];
        final value = parts.sublist(1).join(':');
        
        switch (command) {
          case 'BATTERY':
            final batteryLevel = int.tryParse(value) ?? 0;
            _currentStatus = _currentStatus.copyWith(
              batteryLevel: batteryLevel,
              lastUpdated: DateTime.now(),
            );
            break;
            
          case 'TEMP':
            final temperature = double.tryParse(value) ?? 0.0;
            _currentStatus = _currentStatus.copyWith(
              temperature: temperature,
              lastUpdated: DateTime.now(),
            );
            break;
            
          case 'RAIN':
            _currentStatus = _currentStatus.copyWith(
              rainLevel: value.toLowerCase(),
              lastUpdated: DateTime.now(),
            );
            break;
            
          case 'UMBRELLA':
            final isOpen = value.toUpperCase() == 'OPEN';
            _currentStatus = _currentStatus.copyWith(
              umbrellaOpen: isOpen,
              lastUpdated: DateTime.now(),
            );
            break;
            
          case 'STATUS':
            // Handle complete status update
            if (value == 'READY') {
              _currentStatus = _currentStatus.copyWith(
                lastUpdated: DateTime.now(),
              );
            }
            break;
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error handling incoming data: $e');
    }
  }

  // Smart bag control methods
  Future<void> openUmbrella() async {
    await _sendCommand('UMBRELLA:OPEN');
  }

  Future<void> closeUmbrella() async {
    await _sendCommand('UMBRELLA:CLOSE');
  }

  Future<void> requestBatteryLevel() async {
    await _sendCommand('GET_BATTERY');
  }

  Future<void> requestTemperature() async {
    await _sendCommand('GET_TEMP');
  }

  Future<void> requestAllStatus() async {
    await _sendCommand('GET_STATUS');
  }

  Future<void> setSmsNumber(String phoneNumber) async {
    await _sendCommand('SET_SMS:$phoneNumber');
  }

  Future<void> getSmsNumber() async {
    await _sendCommand('GET_SMS');
  }

  Future<void> setAdminPin(String pin) async {
    await _sendCommand('SET_PIN:$pin');
  }

  @override
  void dispose() {
    _disconnect();
    _discoverySubscription?.cancel();
    super.dispose();
  }
}