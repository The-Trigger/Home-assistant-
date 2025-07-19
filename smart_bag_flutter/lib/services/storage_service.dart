import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  SharedPreferences? _prefs;
  
  // Storage keys
  static const String _adminPinKey = 'admin_pin';
  static const String _smsNumberKey = 'sms_number';
  static const String _lastAuthTimeKey = 'last_auth_time';
  static const String _lastAdminAuthTimeKey = 'last_admin_auth_time';
  static const String _failedPinAttemptsKey = 'failed_pin_attempts';
  static const String _pinLockoutTimeKey = 'pin_lockout_time';
  static const String _lastConnectedDeviceKey = 'last_connected_device';
  static const String _appSettingsKey = 'app_settings';
  static const String _bagStatusHistoryKey = 'bag_status_history';

  Future<void> _initializePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Admin PIN management
  Future<String?> getAdminPin() async {
    await _initializePrefs();
    return _prefs!.getString(_adminPinKey);
  }

  Future<void> setAdminPin(String pin) async {
    await _initializePrefs();
    await _prefs!.setString(_adminPinKey, pin);
    notifyListeners();
  }

  Future<void> clearAdminPin() async {
    await _initializePrefs();
    await _prefs!.remove(_adminPinKey);
    notifyListeners();
  }

  // SMS number management
  Future<String?> getSmsNumber() async {
    await _initializePrefs();
    return _prefs!.getString(_smsNumberKey);
  }

  Future<void> setSmsNumber(String phoneNumber) async {
    await _initializePrefs();
    await _prefs!.setString(_smsNumberKey, phoneNumber);
    notifyListeners();
  }

  Future<void> clearSmsNumber() async {
    await _initializePrefs();
    await _prefs!.remove(_smsNumberKey);
    notifyListeners();
  }

  // Authentication timing
  Future<DateTime?> getLastAuthTime() async {
    await _initializePrefs();
    final timestamp = _prefs!.getInt(_lastAuthTimeKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setLastAuthTime(DateTime time) async {
    await _initializePrefs();
    await _prefs!.setInt(_lastAuthTimeKey, time.millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastAdminAuthTime() async {
    await _initializePrefs();
    final timestamp = _prefs!.getInt(_lastAdminAuthTimeKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setLastAdminAuthTime(DateTime time) async {
    await _initializePrefs();
    await _prefs!.setInt(_lastAdminAuthTimeKey, time.millisecondsSinceEpoch);
  }

  // Failed PIN attempts management
  Future<int> getFailedPinAttempts() async {
    await _initializePrefs();
    return _prefs!.getInt(_failedPinAttemptsKey) ?? 0;
  }

  Future<int> incrementFailedPinAttempts() async {
    await _initializePrefs();
    final current = await getFailedPinAttempts();
    final newCount = current + 1;
    await _prefs!.setInt(_failedPinAttemptsKey, newCount);
    return newCount;
  }

  Future<void> resetFailedPinAttempts() async {
    await _initializePrefs();
    await _prefs!.setInt(_failedPinAttemptsKey, 0);
  }

  // PIN lockout management
  Future<DateTime?> getPinLockoutTime() async {
    await _initializePrefs();
    final timestamp = _prefs!.getInt(_pinLockoutTimeKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setPinLockoutTime(DateTime time) async {
    await _initializePrefs();
    await _prefs!.setInt(_pinLockoutTimeKey, time.millisecondsSinceEpoch);
  }

  Future<void> clearPinLockoutTime() async {
    await _initializePrefs();
    await _prefs!.remove(_pinLockoutTimeKey);
  }

  // Last connected device
  Future<String?> getLastConnectedDevice() async {
    await _initializePrefs();
    return _prefs!.getString(_lastConnectedDeviceKey);
  }

  Future<void> setLastConnectedDevice(String deviceAddress) async {
    await _initializePrefs();
    await _prefs!.setString(_lastConnectedDeviceKey, deviceAddress);
    notifyListeners();
  }

  Future<void> clearLastConnectedDevice() async {
    await _initializePrefs();
    await _prefs!.remove(_lastConnectedDeviceKey);
    notifyListeners();
  }

  // App settings
  Future<Map<String, dynamic>> getAppSettings() async {
    await _initializePrefs();
    final settingsString = _prefs!.getString(_appSettingsKey);
    if (settingsString != null) {
      try {
        return Map<String, dynamic>.from(
          jsonDecode(settingsString)
        );
      } catch (e) {
        debugPrint('Error parsing app settings: $e');
      }
    }
    return _getDefaultSettings();
  }

  Future<void> setAppSettings(Map<String, dynamic> settings) async {
    await _initializePrefs();
    final settingsString = jsonEncode(settings);
    await _prefs!.setString(_appSettingsKey, settingsString);
    notifyListeners();
  }

  Future<void> updateAppSetting(String key, dynamic value) async {
    final settings = await getAppSettings();
    settings[key] = value;
    await setAppSettings(settings);
  }

  Map<String, dynamic> _getDefaultSettings() {
    return {
      'autoConnect': true,
      'notificationsEnabled': true,
      'batteryAlertThreshold': 20,
      'temperatureUnit': 'celsius',
      'statusUpdateInterval': 2000,
      'darkMode': false,
      'soundEnabled': true,
      'vibrationEnabled': true,
    };
  }

  // Status history (for analytics/debugging)
  Future<List<Map<String, dynamic>>> getStatusHistory() async {
    await _initializePrefs();
    final historyString = _prefs!.getString(_bagStatusHistoryKey);
    if (historyString != null) {
      try {
        final List<dynamic> historyList = jsonDecode(historyString);
        return historyList.cast<Map<String, dynamic>>();
      } catch (e) {
        debugPrint('Error parsing status history: $e');
      }
    }
    return [];
  }

  Future<void> addStatusToHistory(Map<String, dynamic> status) async {
    await _initializePrefs();
    final history = await getStatusHistory();
    
    // Add timestamp if not present
    status['timestamp'] = DateTime.now().toIso8601String();
    
    // Add to beginning of list
    history.insert(0, status);
    
    // Keep only last 100 entries
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }
    
    final historyString = jsonEncode(history);
    await _prefs!.setString(_bagStatusHistoryKey, historyString);
  }

  Future<void> clearStatusHistory() async {
    await _initializePrefs();
    await _prefs!.remove(_bagStatusHistoryKey);
    notifyListeners();
  }

  // Utility methods
  Future<void> clearAllData() async {
    await _initializePrefs();
    await _prefs!.clear();
    notifyListeners();
  }

  Future<void> clearAuthenticationData() async {
    await _initializePrefs();
    await _prefs!.remove(_lastAuthTimeKey);
    await _prefs!.remove(_lastAdminAuthTimeKey);
    await _prefs!.remove(_failedPinAttemptsKey);
    await _prefs!.remove(_pinLockoutTimeKey);
    notifyListeners();
  }

  Future<bool> hasAnyData() async {
    await _initializePrefs();
    return _prefs!.getKeys().isNotEmpty;
  }

  Future<Map<String, dynamic>> exportData() async {
    await _initializePrefs();
    final data = <String, dynamic>{};
    
    for (final key in _prefs!.getKeys()) {
      // Don't export sensitive data like PIN
      if (key != _adminPinKey && key != _pinLockoutTimeKey) {
        data[key] = _prefs!.get(key);
      }
    }
    
    return data;
  }

  Future<void> importData(Map<String, dynamic> data) async {
    await _initializePrefs();
    
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Don't import sensitive data
      if (key == _adminPinKey || key == _pinLockoutTimeKey) {
        continue;
      }
      
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs!.setStringList(key, value);
      }
    }
    
    notifyListeners();
  }
}