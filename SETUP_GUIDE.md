# Smart Bag Controller - Complete Setup Guide

This repository contains **TWO** mobile app implementations for the Smart Bag Controller:

1. **React Native App** (Original) - Located in root directory
2. **Flutter App** (New) - Located in `smart_bag_flutter/` directory

## 🎯 Choose Your Implementation

### React Native App (Original)
- **Location**: Root directory
- **Technology**: React Native + JavaScript
- **Status**: Complete and functional
- **Best for**: React/JavaScript developers

### Flutter App (New) 
- **Location**: `smart_bag_flutter/` directory
- **Technology**: Flutter + Dart
- **Status**: Complete with enhanced features
- **Best for**: Dart/Flutter developers, better performance

## 🚀 Quick Start

### Option 1: React Native App

```bash
# Install dependencies
npm install

# For Android
npx react-native run-android

# For iOS (macOS only)
npx react-native run-ios
```

### Option 2: Flutter App

```bash
# Navigate to Flutter app
cd smart_bag_flutter

# Install dependencies  
flutter pub get

# Run on connected device
flutter run

# Or build APK
flutter build apk --debug
```

## 🛠️ Hardware Setup (Same for Both Apps)

### Arduino Mega 2560 Connections
```
Pin 2  → Bluetooth RX (HC-05/HC-06)
Pin 3  → Bluetooth TX (HC-05/HC-06)  
Pin 9  → Servo Motor Signal
Pin 13 → LED Indicator
Pin A0 → Battery Level Input
Pin A1 → Temperature Sensor (LM35)
```

### Required Components
- Arduino Mega 2560
- HC-05 or HC-06 Bluetooth Module
- Servo Motor (for umbrella)
- LM35 Temperature Sensor  
- LED Indicator
- Battery monitoring circuit
- Connecting wires

## 📱 App Features Comparison

| Feature | React Native | Flutter |
|---------|-------------|---------|
| Fingerprint Auth | ✅ | ✅ |
| Bluetooth Control | ✅ | ✅ |
| Umbrella Control | ✅ | ✅ |
| Battery Monitoring | ✅ | ✅ |
| Temperature Sensing | ✅ | ✅ |
| SMS Configuration | ✅ | ✅ |
| Admin PIN | ✅ | ✅ |
| Modern UI | ✅ | ✅✅ |
| Animations | ✅ | ✅✅ |
| Performance | ✅ | ✅✅ |

## 🔧 Arduino Code Upload

Both apps use the **same Arduino code**:

1. Open Arduino IDE
2. Load: `arduino/smart_bag_controller/smart_bag_controller.ino`
3. Select Board: Arduino Mega 2560
4. Upload the code

## 📋 Mobile App Setup

### Android Permissions Required
- Bluetooth
- Location (for BT scanning)
- Biometric/Fingerprint
- SMS (optional)

### First Time Setup
1. Launch app
2. Grant permissions
3. Setup fingerprint/PIN authentication
4. Pair with Arduino Bluetooth module
5. Configure SMS number (optional)

## 🎮 Usage Instructions

### Connecting to Smart Bag
1. Tap Bluetooth icon in app
2. Scan for devices
3. Select your Arduino module
4. Wait for connection

### Controlling Umbrella
1. Navigate to Control section
2. Tap "Open" or "Close"
3. Watch LED feedback on Arduino

### Monitoring Status
- Battery level with color coding
- Temperature readings
- Connection status
- Real-time updates

## 📡 Communication Protocol

Both apps use the same command protocol:

### Commands to Arduino:
```
UMBRELLA:OPEN         # Open umbrella
UMBRELLA:CLOSE        # Close umbrella  
GET_BATTERY          # Request battery level
GET_TEMP             # Request temperature
GET_STATUS           # Request all status
SET_SMS:+1234567890  # Set SMS number
```

### Arduino Responses:
```
BATTERY:85           # Battery level %
TEMP:23.5           # Temperature °C
UMBRELLA:OPEN       # Umbrella status
SMS:NUMBER:+1234567890  # SMS number
STATUS:READY        # Status message
```

## 🔍 Troubleshooting

### Common Issues

#### Can't Connect to Arduino
- Check Bluetooth pairing
- Verify Arduino power
- Ensure baud rate is 9600
- Check module appears in phone settings

#### Authentication Problems  
- Grant biometric permissions
- Ensure fingerprints enrolled
- Try PIN fallback
- Restart app

#### Umbrella Not Moving
- Check servo connections (Pin 9)
- Verify Arduino power supply
- Test with serial monitor
- Check for obstructions

## 🔧 Development Setup

### React Native Requirements
```bash
# Install Node.js 14+
# Install React Native CLI
npm install -g react-native-cli

# Android Studio for Android development
# Xcode for iOS development (macOS only)
```

### Flutter Requirements
```bash
# Install Flutter SDK
# Download from: https://flutter.dev/docs/get-started/install

# Verify installation
flutter doctor

# Android Studio or VS Code with Flutter extension
```

## 📊 Performance Notes

### React Native App
- Smooth performance on modern devices
- Good Bluetooth connectivity
- Responsive UI with animations

### Flutter App  
- Enhanced performance and animations
- Better state management
- More polished UI/UX
- Faster startup time

## 🚀 Advanced Configuration

### Custom Commands
Add new commands by:
1. Extending Arduino `handleCommand()` function
2. Adding corresponding app service methods
3. Updating UI to trigger new commands

### Sensor Calibration
```arduino
// Adjust in Arduino code based on your setup
batteryLevel = map(analogRead(A0), 0, 1023, 0, 100);
temperature = ((analogRead(A1) * 5.0) / 1024.0) * 100.0;
```

## 📞 Support

- **Hardware Issues**: Check Arduino serial monitor at 9600 baud
- **App Issues**: Check device logs and permissions
- **Bluetooth Issues**: Verify pairing and range
- **General Help**: See individual app README files

## 🎯 Recommendations

### For Beginners
- Start with React Native app (simpler setup)
- Use provided Arduino code as-is
- Follow hardware wiring diagram exactly

### For Advanced Users  
- Try Flutter app for better performance
- Customize Arduino code for your needs
- Add additional sensors and features

---

Choose the app that best fits your development environment and preferences. Both implementations provide complete smart bag control functionality!

**Happy coding!** 🎒📱⚡