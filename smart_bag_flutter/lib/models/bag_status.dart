class BagStatus {
  final int batteryLevel;
  final double temperature;
  final String rainLevel;
  final bool umbrellaOpen;
  final bool isConnected;
  final DateTime lastUpdated;

  BagStatus({
    required this.batteryLevel,
    required this.temperature,
    required this.rainLevel,
    required this.umbrellaOpen,
    required this.isConnected,
    required this.lastUpdated,
  });

  factory BagStatus.fromJson(Map<String, dynamic> json) {
    return BagStatus(
      batteryLevel: json['batteryLevel'] ?? 0,
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      rainLevel: json['rainLevel'] ?? 'none',
      umbrellaOpen: json['umbrellaOpen'] ?? false,
      isConnected: json['isConnected'] ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batteryLevel': batteryLevel,
      'temperature': temperature,
      'rainLevel': rainLevel,
      'umbrellaOpen': umbrellaOpen,
      'isConnected': isConnected,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  BagStatus copyWith({
    int? batteryLevel,
    double? temperature,
    String? rainLevel,
    bool? umbrellaOpen,
    bool? isConnected,
    DateTime? lastUpdated,
  }) {
    return BagStatus(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      temperature: temperature ?? this.temperature,
      rainLevel: rainLevel ?? this.rainLevel,
      umbrellaOpen: umbrellaOpen ?? this.umbrellaOpen,
      isConnected: isConnected ?? this.isConnected,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  String get batteryStatus {
    if (batteryLevel > 60) return 'Good';
    if (batteryLevel > 30) return 'Medium';
    if (batteryLevel > 10) return 'Low';
    return 'Critical';
  }

  String get temperatureStatus {
    if (temperature < 10) return 'Cold';
    if (temperature < 25) return 'Normal';
    if (temperature < 35) return 'Warm';
    return 'Hot';
  }

  String get umbrellaStatus => umbrellaOpen ? 'Open' : 'Closed';

  String get connectionStatus => isConnected ? 'Connected' : 'Disconnected';
  
  bool get needsUmbrella => rainLevel != 'none';
  
  bool get batteryNeedsCharging => batteryLevel < 20;

  @override
  String toString() {
    return 'BagStatus(batteryLevel: $batteryLevel, temperature: $temperature, '
           'rainLevel: $rainLevel, umbrellaOpen: $umbrellaOpen, '
           'isConnected: $isConnected, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BagStatus &&
        other.batteryLevel == batteryLevel &&
        other.temperature == temperature &&
        other.rainLevel == rainLevel &&
        other.umbrellaOpen == umbrellaOpen &&
        other.isConnected == isConnected &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return batteryLevel.hashCode ^
        temperature.hashCode ^
        rainLevel.hashCode ^
        umbrellaOpen.hashCode ^
        isConnected.hashCode ^
        lastUpdated.hashCode;
  }
}