# Smart Bag Controller Mobile App

A React Native mobile application for controlling a smart bag with fingerprint authentication, Bluetooth connectivity, and comprehensive bag management features.

## 🎒 Features

### 🔐 Security
- **Fingerprint Authentication**: Secure access using mobile device fingerprint scanner
- **Biometric Fallback**: Alternative authentication methods when fingerprint is unavailable

### 📱 Connectivity
- **Bluetooth Integration**: Connect to Arduino Mega via Bluetooth module
- **Auto-reconnection**: Automatically reconnect to previously paired devices
- **Device Management**: Scan and pair with new Bluetooth devices

### ☂️ Smart Umbrella Control
- **Open/Close Control**: Control umbrella mechanism with smooth servo movements
- **Status Monitoring**: Real-time umbrella position feedback
- **Visual Feedback**: LED indicators on Arduino for operation status

### 🔋 Monitoring & Sensors
- **Battery Level**: Real-time battery percentage monitoring with color-coded indicators
- **Temperature Monitoring**: Ambient temperature tracking with status indicators
- **Low Battery Alerts**: Automatic warnings when battery level is critical

### 📱 SMS Configuration
- **Phone Number Management**: Configure SMS notification number
- **Number Validation**: Input validation for phone number formats
- **Persistent Storage**: SMS number saved in Arduino EEPROM

### 🎨 User Interface
- **Modern Design**: Beautiful gradient backgrounds and animations
- **Intuitive Controls**: Easy-to-use touch controls with visual feedback
- **Real-time Updates**: Live data refresh with pull-to-refresh functionality
- **Responsive Layout**: Optimized for various screen sizes

## 🛠️ Hardware Requirements

### Arduino Mega Components
- **Arduino Mega 2560**
- **HC-05/HC-06 Bluetooth Module**
- **Servo Motor** (for umbrella mechanism)
- **LM35 Temperature Sensor**
- **Battery Level Monitoring Circuit**
- **LED Indicator**
- **Connecting Wires and Breadboard**

### Mobile Device Requirements
- **Android 6.0+** (API level 23)
- **Bluetooth 4.0+**
- **Fingerprint Scanner** (optional but recommended)

## 📋 Installation & Setup

### 1. Mobile App Setup

```bash
# Clone the repository
git clone <repository-url>
cd smart-bag-controller

# Install dependencies
npm install

# For Android development
npx react-native run-android

# For iOS development (requires macOS)
npx react-native run-ios
```

### 2. Arduino Setup

1. **Hardware Connections:**
   ```
   Arduino Mega Pin Connections:
   - Pin 2: Bluetooth RX
   - Pin 3: Bluetooth TX
   - Pin 9: Servo Motor Signal
   - Pin A0: Battery Level Input
   - Pin A1: Temperature Sensor (LM35)
   - Pin 13: LED Indicator
   ```

2. **Upload Arduino Code:**
   - Open `arduino/smart_bag_controller/smart_bag_controller.ino` in Arduino IDE
   - Select "Arduino Mega 2560" as board
   - Upload the code to your Arduino

3. **Bluetooth Module Configuration:**
   - Connect HC-05/HC-06 to pins 2 and 3
   - Ensure baud rate is set to 9600
   - Pair the module with your mobile device

### 3. App Configuration

1. **Grant Permissions:**
   - Bluetooth access
   - Location access (required for Bluetooth scanning)
   - Biometric authentication

2. **First-time Setup:**
   - Launch the app
   - Complete fingerprint authentication
   - Connect to your Arduino Bluetooth device
   - Configure SMS number for notifications

## 🚀 Usage Guide

### Authentication
1. Launch the app
2. Place finger on device fingerprint scanner
3. Wait for authentication confirmation

### Connecting to Smart Bag
1. Tap the "Connect" button in the top-right corner
2. Select your Arduino device from the list
3. Wait for connection confirmation
4. Green "Connected" indicator will appear

### Controlling the Umbrella
1. Navigate to "Umbrella Control" section
2. Tap "Open" to extend the umbrella
3. Tap "Close" to retract the umbrella
4. Status updates in real-time

### Monitoring Status
- **Battery Level**: Displayed with color-coded indicators
  - Green: >60%
  - Orange: 30-60%
  - Red: <30%
- **Temperature**: Shows current ambient temperature
- **Refresh**: Pull down to refresh all data

### SMS Configuration
1. Tap "Configure SMS Number"
2. Enter a valid phone number
3. Tap "Update Number"
4. Number is saved to Arduino EEPROM

## 📡 Communication Protocol

The app communicates with Arduino using a simple text-based protocol:

### Commands Sent to Arduino:
- `UMBRELLA:OPEN` - Open umbrella
- `UMBRELLA:CLOSE` - Close umbrella
- `GET_BATTERY` - Request battery level
- `GET_TEMP` - Request temperature
- `GET_STATUS` - Request all status data
- `SET_SMS:+1234567890` - Set SMS number
- `GET_SMS` - Get current SMS number

### Responses from Arduino:
- `BATTERY:85` - Battery level percentage
- `TEMP:23.5` - Temperature in Celsius
- `UMBRELLA:OPEN` - Umbrella status
- `SMS:NUMBER:+1234567890` - Current SMS number
- `STATUS:READY` - General status messages

## 🔧 Troubleshooting

### Common Issues

1. **Cannot Connect to Arduino:**
   - Ensure Bluetooth module is powered and paired
   - Check if device appears in phone's Bluetooth settings
   - Verify baud rate is 9600 on both sides

2. **Fingerprint Authentication Fails:**
   - Ensure device has fingerprint capability
   - Check if fingerprints are enrolled in device settings
   - Grant biometric permissions to the app

3. **Umbrella Not Responding:**
   - Check servo motor connections
   - Verify power supply to Arduino
   - Test with serial monitor first

4. **Sensor Readings Incorrect:**
   - Check sensor connections
   - Verify voltage levels
   - Calibrate sensors if necessary

### Debug Mode
Enable debug logging by connecting Arduino to USB and opening Serial Monitor at 9600 baud rate.

## 🔄 Updates & Maintenance

### Updating the App
```bash
# Pull latest changes
git pull origin main

# Install new dependencies
npm install

# Rebuild the app
npx react-native run-android
```

### Arduino Code Updates
1. Make changes to `.ino` file
2. Upload via Arduino IDE
3. SMS number and settings are preserved in EEPROM

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check troubleshooting section
- Review Arduino serial output for debugging

## 🔮 Future Enhancements

- [ ] GPS tracking integration
- [ ] Weather API integration
- [ ] Remote SMS notifications
- [ ] Battery optimization
- [ ] Voice control
- [ ] Multiple bag support
- [ ] Cloud synchronization

---

**Note**: This project is designed for educational and prototyping purposes. For commercial use, ensure proper testing and safety measures are implemented.
