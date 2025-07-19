class BluetoothDeviceModel {
  final String name;
  final String address;
  final bool isConnected;
  final bool isBonded;
  final int? rssi;
  final DateTime? lastSeen;

  BluetoothDeviceModel({
    required this.name,
    required this.address,
    this.isConnected = false,
    this.isBonded = false,
    this.rssi,
    this.lastSeen,
  });

  factory BluetoothDeviceModel.fromJson(Map<String, dynamic> json) {
    return BluetoothDeviceModel(
      name: json['name'] ?? 'Unknown Device',
      address: json['address'] ?? '',
      isConnected: json['isConnected'] ?? false,
      isBonded: json['isBonded'] ?? false,
      rssi: json['rssi'],
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'isConnected': isConnected,
      'isBonded': isBonded,
      'rssi': rssi,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  BluetoothDeviceModel copyWith({
    String? name,
    String? address,
    bool? isConnected,
    bool? isBonded,
    int? rssi,
    DateTime? lastSeen,
  }) {
    return BluetoothDeviceModel(
      name: name ?? this.name,
      address: address ?? this.address,
      isConnected: isConnected ?? this.isConnected,
      isBonded: isBonded ?? this.isBonded,
      rssi: rssi ?? this.rssi,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  String get displayName {
    if (name.isNotEmpty && name != 'Unknown Device') {
      return name;
    }
    return 'Device ${address.substring(address.length - 5)}';
  }

  String get connectionStatusText {
    if (isConnected) return 'Connected';
    if (isBonded) return 'Paired';
    return 'Available';
  }

  String get signalStrengthText {
    if (rssi == null) return 'Unknown';
    if (rssi! > -50) return 'Excellent';
    if (rssi! > -70) return 'Good';
    if (rssi! > -85) return 'Fair';
    return 'Poor';
  }

  bool get isSmartBagDevice {
    final nameUpper = name.toUpperCase();
    return nameUpper.contains('SMART') ||
           nameUpper.contains('BAG') ||
           nameUpper.contains('HC-05') ||
           nameUpper.contains('HC-06') ||
           nameUpper.contains('ARDUINO');
  }

  @override
  String toString() {
    return 'BluetoothDevice(name: $name, address: $address, '
           'isConnected: $isConnected, isBonded: $isBonded, '
           'rssi: $rssi, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BluetoothDeviceModel &&
        other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}