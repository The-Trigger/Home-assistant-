# Smart Bag Controller - Flutter Mobile App

A comprehensive Flutter mobile application for controlling a smart bag with fingerprint authentication, Bluetooth connectivity, and Arduino Mega integration.

## 🎒 Features

### 🔐 Security & Authentication
- **Fingerprint Authentication**: Secure access using mobile device biometric scanner
- **Admin PIN**: Fallback authentication with PIN verification
- **Session Management**: Automatic session expiry for enhanced security
- **Failed Attempt Protection**: Automatic lockout after multiple failed PIN attempts

### 📱 Bluetooth Connectivity
- **Arduino Mega Integration**: Direct communication with Arduino Mega via Bluetooth module (HC-05/HC-06)
- **Device Discovery**: Automatic scanning and pairing with Bluetooth devices
- **Auto-reconnection**: Seamlessly reconnect to previously paired devices
- **Real-time Communication**: Live data exchange with Arduino for status updates

### ☂️ Smart Umbrella Control
- **Open/Close Control**: Remote umbrella mechanism control with smooth servo movements
- **Status Monitoring**: Real-time umbrella position feedback
- **Visual Feedback**: LED indicators on Arduino for operation status
- **Emergency Control**: Quick response umbrella controls

### 🔋 Comprehensive Monitoring
- **Battery Level**: Real-time battery percentage monitoring with color-coded indicators
  - Green: >60% (Good)
  - Orange: 30-60% (Medium)
  - Red: 10-30% (Low)
  - Dark Red: <10% (Critical)
- **Temperature Monitoring**: Ambient temperature tracking with status indicators
- **Rain Detection**: Rain level monitoring for automatic umbrella suggestions
- **Low Battery Alerts**: Automatic warnings and notifications

### 📱 Smart Configuration
- **SMS Number Management**: Configure SMS notification number for alerts
- **Admin PIN Setup**: Secure PIN configuration and management
- **Settings Persistence**: All settings saved to Arduino EEPROM
- **Number Validation**: Input validation for phone numbers and PIN formats

### 🎨 Modern User Interface
- **Material Design 3**: Beautiful and intuitive user interface
- **Gradient Backgrounds**: Eye-catching visual design
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Real-time Updates**: Live data refresh with pull-to-refresh functionality
- **Responsive Layout**: Optimized for various Android screen sizes
- **Dark/Light Theme Support**: Automatic theme adaptation

## 🛠️ Hardware Requirements

### Arduino Mega Setup
```
Arduino Mega 2560 Pin Connections:
- Pin 2: Bluetooth RX (HC-05/HC-06)
- Pin 3: Bluetooth TX (HC-05/HC-06)
- Pin 9: Servo Motor Signal (Umbrella)
- Pin 13: LED Indicator
- Pin A0: Battery Level Monitoring
- Pin A1: Temperature Sensor (LM35)
- 5V/GND: Power connections
```

### Required Components
- **Arduino Mega 2560**
- **HC-05 or HC-06 Bluetooth Module**
- **Servo Motor** (for umbrella mechanism)
- **LM35 Temperature Sensor**
- **Battery Level Monitoring Circuit**
- **LED Indicator**
- **Connecting Wires and Breadboard**

### Mobile Device Requirements
- **Android 6.0+** (API level 23)
- **Bluetooth 4.0+**
- **Fingerprint Scanner** (optional but recommended)
- **4GB+ RAM** (recommended)

## 📋 Installation & Setup

### 1. Development Environment Setup

```bash
# Install Flutter (if not already installed)
# Download Flutter SDK from https://flutter.dev/docs/get-started/install

# Verify Flutter installation
flutter doctor

# Clone or download the project
git clone <repository-url>
cd smart_bag_flutter

# Install dependencies
flutter pub get

# Check for any issues
flutter analyze
```

### 2. Arduino Setup

1. **Hardware Assembly:**
   - Connect components according to the pin diagram above
   - Ensure proper power connections (5V/GND)
   - Double-check Bluetooth module wiring

2. **Arduino Code Upload:**
   ```bash
   # Open Arduino IDE
   # Load: arduino/smart_bag_controller/smart_bag_controller.ino
   # Select: Tools -> Board -> Arduino Mega 2560
   # Select: Tools -> Port -> [Your Arduino Port]
   # Click: Upload
   ```

3. **Bluetooth Configuration:**
   - Pair HC-05/HC-06 module with mobile device
   - Default baud rate: 9600
   - Note the device name/address for app connection

### 3. Mobile App Installation

#### For Development:
```bash
# Enable Developer Options on Android device
# Enable USB Debugging
# Connect device via USB

# Install debug APK
flutter run

# Or build APK manually
flutter build apk --debug
# Install: build/app/outputs/flutter-apk/app-debug.apk
```

#### For Production:
```bash
# Build release APK
flutter build apk --release

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 4. App Configuration

1. **First Launch:**
   - Grant required permissions (Bluetooth, Location, Biometric)
   - Complete fingerprint authentication setup
   - Set up admin PIN (4-8 digits)

2. **Bluetooth Connection:**
   - Tap Bluetooth icon in app header
   - Scan for devices
   - Select your Arduino Bluetooth module
   - Wait for connection confirmation

3. **SMS Configuration:**
   - Navigate to Settings
   - Enter SMS notification number
   - Tap "Update Number" to save to Arduino

## 🚀 Usage Guide

### Authentication Flow
1. **Launch App** → Splash screen with loading animation
2. **Fingerprint Auth** → Place finger on sensor
3. **Alternative PIN** → Enter 4-8 digit PIN if fingerprint fails
4. **Main Dashboard** → Access all smart bag features

### Umbrella Control
```
Dashboard → Control Tab → Umbrella Section
- Tap "Open" to extend umbrella
- Tap "Close" to retract umbrella
- Status updates in real-time
- LED indicators on Arduino provide visual feedback
```

### Monitoring & Status
```
Dashboard → Real-time status cards show:
- Battery Level: Percentage with color coding
- Temperature: Current ambient temperature in °C
- Rain Level: Current precipitation status
- Connection: Bluetooth connection status
- Last Update: Timestamp of last data refresh
```

### Settings & Configuration
```
Settings Tab → Configure:
- SMS notification number
- Admin PIN change
- App preferences
- Bluetooth device management
- Data export/import
```

## 📡 Communication Protocol

The app communicates with Arduino using a simple text-based protocol over Bluetooth:

### Commands Sent to Arduino:
```
UMBRELLA:OPEN          - Open umbrella
UMBRELLA:CLOSE         - Close umbrella
GET_BATTERY           - Request battery level
GET_TEMP              - Request temperature
GET_STATUS            - Request all status data
SET_SMS:+1234567890   - Set SMS number
GET_SMS               - Get current SMS number
SET_PIN:1234          - Set admin PIN
```

### Responses from Arduino:
```
BATTERY:85            - Battery level (85%)
TEMP:23.5             - Temperature (23.5°C)
UMBRELLA:OPEN         - Umbrella status
RAIN:LIGHT            - Rain level
SMS:NUMBER:+1234567890 - Current SMS number
STATUS:READY          - General status messages
```

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 1. Bluetooth Connection Problems
```
Problem: Cannot connect to Arduino
Solutions:
- Verify Bluetooth module is powered and paired
- Check Arduino serial monitor for debug messages
- Ensure baud rate is 9600 on both sides
- Try re-pairing the Bluetooth device
- Check if device appears in Android Bluetooth settings
```

#### 2. Fingerprint Authentication Issues
```
Problem: Fingerprint authentication fails
Solutions:
- Ensure device has fingerprint capability
- Check fingerprint enrollment in device settings
- Grant biometric permissions to the app
- Try using PIN authentication as fallback
- Restart app if persistent issues occur
```

#### 3. Umbrella Control Not Responding
```
Problem: Umbrella doesn't open/close
Solutions:
- Check servo motor connections (Pin 9)
- Verify power supply to Arduino (5V)
- Test servo manually with Arduino IDE serial monitor
- Check for mechanical obstructions
- Verify servo PWM signal with oscilloscope
```

#### 4. Sensor Readings Incorrect
```
Problem: Battery/temperature readings are wrong
Solutions:
- Check sensor connections (A0, A1)
- Verify voltage levels with multimeter
- Calibrate sensors using known reference values
- Check for loose connections
- Replace sensors if consistently inaccurate
```

#### 5. App Permissions Issues
```
Problem: App cannot access Bluetooth/biometrics
Solutions:
- Go to Android Settings → Apps → Smart Bag Controller
- Grant all required permissions manually
- Enable location services (required for Bluetooth scanning)
- Restart app after granting permissions
```

### Debug Mode
Enable detailed logging by connecting Arduino to USB and opening Serial Monitor at 9600 baud rate. All commands and responses will be logged for debugging.

## 🔄 Updates & Maintenance

### Updating the Mobile App
```bash
# Pull latest changes
git pull origin main

# Update dependencies
flutter pub get

# Rebuild and reinstall
flutter build apk --release
```

### Arduino Firmware Updates
1. Make changes to `smart_bag_controller.ino`
2. Upload via Arduino IDE
3. SMS number and PIN settings are preserved in EEPROM
4. Test all functionality after update

### Data Backup
- SMS numbers and settings are automatically saved to Arduino EEPROM
- App settings can be exported from Settings menu
- Connection history is maintained locally

## 🏗️ Architecture Overview

### Flutter App Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── bag_status.dart      # Bag status data structure
│   └── bluetooth_device.dart # Bluetooth device model
├── services/                 # Business logic services
│   ├── auth_service.dart    # Authentication & security
│   ├── bluetooth_service.dart # Bluetooth communication
│   └── storage_service.dart # Data persistence
├── screens/                  # UI screens
│   ├── splash_screen.dart   # App startup screen
│   ├── auth_screen.dart     # Authentication UI
│   └── main_screen.dart     # Main app interface
├── widgets/                  # Reusable UI components
│   ├── custom_button.dart   # Custom buttons
│   └── custom_text_field.dart # Custom input fields
└── utils/                    # Utilities
    └── app_colors.dart      # Color scheme
```

### Data Flow
```
User Input → Flutter UI → Bluetooth Service → Arduino → Hardware Action
Hardware Sensors → Arduino → Bluetooth → Flutter Service → UI Update
```

## 📊 Performance Considerations

### Optimization Features
- **Efficient State Management**: Provider pattern for reactive updates
- **Lazy Loading**: Services initialized only when needed
- **Connection Pooling**: Bluetooth connection reuse
- **Battery Optimization**: Intelligent polling intervals
- **Memory Management**: Automatic cleanup of resources

### Recommended Settings
- Sensor update interval: 2-5 seconds
- Connection timeout: 10 seconds
- Session expiry: 30 minutes (user), 15 minutes (admin)
- Data history: Last 100 status updates

## 🔮 Future Enhancements

### Planned Features
- [ ] **GPS Integration**: Location tracking for bag security
- [ ] **Weather API**: Automatic umbrella suggestions
- [ ] **Cloud Sync**: Backup settings to cloud storage
- [ ] **Multiple Bag Support**: Control several smart bags
- [ ] **Voice Control**: Hands-free operation
- [ ] **Wear OS Integration**: Smartwatch companion app
- [ ] **NFC Support**: Quick pair and authentication
- [ ] **Machine Learning**: Predictive umbrella control

### Hardware Upgrades
- [ ] **Solar Charging**: Renewable power source
- [ ] **WiFi Module**: Internet connectivity
- [ ] **Camera Integration**: Security monitoring
- [ ] **Pressure Sensors**: Weight monitoring
- [ ] **RFID Tracking**: Item identification

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Write comprehensive tests
- Update documentation for new features
- Ensure backward compatibility with Arduino code

## 📞 Support

For technical support and questions:
- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: Check troubleshooting section
- **Arduino Debug**: Use serial monitor for hardware debugging
- **Community**: Join discussions in project repository

## 🔧 Advanced Configuration

### Custom Protocol Commands
Add new commands by extending the Arduino `handleCommand()` function and corresponding Flutter service methods.

### Sensor Calibration
```arduino
// Battery calibration (adjust based on your voltage divider)
batteryLevel = map(batteryReading, 200, 900, 0, 100);

// Temperature calibration (adjust for sensor type)
temperature = (voltage * 100.0) + offset;
```

### Security Enhancements
- Implement command encryption for sensitive operations
- Add command authentication with HMAC
- Enable secure pairing with PIN verification

---

**Smart Bag Controller v1.0.0** - Revolutionizing personal bag management with smart technology, secure authentication, and seamless mobile control.

Built with ❤️ using Flutter, Arduino, and modern mobile development practices.
