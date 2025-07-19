import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  
  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFAFAFA);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Battery level colors
  static const Color batteryHigh = Color(0xFF4CAF50);
  static const Color batteryMedium = Color(0xFFFF9800);
  static const Color batteryLow = Color(0xFFF44336);
  static const Color batteryCritical = Color(0xFFD32F2F);
  
  // Temperature colors
  static const Color tempCold = Color(0xFF2196F3);
  static const Color tempNormal = Color(0xFF4CAF50);
  static const Color tempWarm = Color(0xFFFF9800);
  static const Color tempHot = Color(0xFFF44336);
  
  // Rain level colors
  static const Color rainNone = Color(0xFF4CAF50);
  static const Color rainLight = Color(0xFFFFEB3B);
  static const Color rainModerate = Color(0xFFFF9800);
  static const Color rainHeavy = Color(0xFFF44336);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Gray shades
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF616161);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, lightBlue],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightBlue, surfaceWhite],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF66BB6A)],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFFFB74D)],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, Color(0xFFEF5350)],
  );
  
  // Utility methods
  static Color getBatteryColor(int batteryLevel) {
    if (batteryLevel > 60) return batteryHigh;
    if (batteryLevel > 30) return batteryMedium;
    if (batteryLevel > 10) return batteryLow;
    return batteryCritical;
  }
  
  static Color getTemperatureColor(double temperature) {
    if (temperature < 10) return tempCold;
    if (temperature < 25) return tempNormal;
    if (temperature < 35) return tempWarm;
    return tempHot;
  }
  
  static Color getRainColor(String rainLevel) {
    switch (rainLevel.toLowerCase()) {
      case 'none':
        return rainNone;
      case 'light':
        return rainLight;
      case 'moderate':
        return rainModerate;
      case 'heavy':
        return rainHeavy;
      default:
        return rainNone;
    }
  }
}