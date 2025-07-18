# Hardware Setup Guide

This guide covers the hardware setup for the Smart Bag Controller project using Arduino Mega and various sensors.

## 🛠️ Required Components

### Main Components
- **Arduino Mega 2560** - Main microcontroller
- **HC-05 or HC-06 Bluetooth Module** - Wireless communication
- **Servo Motor (SG90 or similar)** - Umbrella mechanism control
- **LM35 Temperature Sensor** - Temperature monitoring
- **LED** - Status indicator
- **Resistors** - Current limiting and voltage dividers
- **Breadboard and Jumper Wires** - Connections

### Additional Components
- **Battery Pack** - Power source for portable operation
- **Voltage Divider Circuit** - Battery level monitoring
- **Pull-up Resistors** - I2C communication stability
- **Capacitors** - Power supply filtering

## 🔌 Pin Connections

### Arduino Mega Pin Assignment

| Component | Arduino Pin | Description |
|-----------|-------------|-------------|
| HC-05 VCC | 5V | Power supply |
| HC-05 GND | GND | Ground |
| HC-05 RX | Pin 2 | Bluetooth receive |
| HC-05 TX | Pin 3 | Bluetooth transmit |
| Servo Signal | Pin 9 | PWM control signal |
| Servo VCC | 5V | Power supply |
| Servo GND | GND | Ground |
| LM35 VCC | 5V | Power supply |
| LM35 OUT | A1 | Analog temperature reading |
| LM35 GND | GND | Ground |
| Battery Monitor | A0 | Battery voltage reading |
| Status LED | Pin 13 | Built-in LED |

## 🔧 Detailed Wiring

### Bluetooth Module (HC-05/HC-06)
```
HC-05/HC-06 Module:
VCC  ➜  Arduino 5V
GND  ➜  Arduino GND
TXD  ➜  Arduino Pin 2 (RX)
RXD  ➜  Arduino Pin 3 (TX)
```

**Note**: Some HC-05 modules operate at 3.3V. If your module is 3.3V, use a voltage divider or level shifter for the RX pin.

### Servo Motor Connection
```
Servo Motor:
Red Wire (VCC)    ➜  Arduino 5V
Brown Wire (GND)  ➜  Arduino GND
Orange Wire (SIG) ➜  Arduino Pin 9
```

### Temperature Sensor (LM35)
```
LM35 Temperature Sensor:
Pin 1 (VCC) ➜  Arduino 5V
Pin 2 (OUT) ➜  Arduino A1
Pin 3 (GND) ➜  Arduino GND
```

### Battery Monitoring Circuit
```
Battery Voltage Divider:
Battery (+) ➜ 10kΩ ➜ Arduino A0 ➜ 10kΩ ➜ GND
```

This creates a 50% voltage divider to safely monitor battery voltage.

## ⚙️ Assembly Instructions

### Step 1: Prepare the Breadboard
1. Place the Arduino Mega on your workspace
2. Set up a breadboard next to it
3. Connect power rails (5V and GND) from Arduino to breadboard

### Step 2: Install Bluetooth Module
1. Place HC-05/HC-06 on breadboard
2. Connect VCC to 5V rail
3. Connect GND to ground rail
4. Connect TX to Arduino Pin 2
5. Connect RX to Arduino Pin 3

### Step 3: Install Servo Motor
1. Connect servo directly to Arduino (short wires)
2. Red wire to 5V
3. Brown wire to GND
4. Orange wire to Pin 9

### Step 4: Install Temperature Sensor
1. Place LM35 on breadboard (flat side facing you)
2. Left pin (VCC) to 5V rail
3. Middle pin (OUT) to Arduino A1
4. Right pin (GND) to ground rail

### Step 5: Battery Monitoring
1. Create voltage divider with two 10kΩ resistors
2. Connect battery positive to first resistor
3. Connect junction to Arduino A0
4. Connect second resistor to ground

### Step 6: Status LED
The built-in LED on Pin 13 is used, no additional wiring needed.

## 🔋 Power Supply Considerations

### For Development
- Use USB power from computer
- Arduino Mega draws ~50mA
- Additional components add ~100mA total

### For Portable Operation
- Use 7-12V battery pack connected to Arduino power jack
- Or use 5V power bank with USB cable
- Ensure sufficient current capacity (500mA minimum)

### Battery Monitoring
- Use voltage divider to monitor battery level
- Calibrate the readings in software
- Set low battery warning threshold

## 📡 Bluetooth Module Configuration

### HC-05 Setup (if needed)
```
AT Commands (connect at 38400 baud):
AT+NAME=SmartBag        // Set device name
AT+PSWD=1234           // Set pairing password
AT+UART=9600,0,0       // Set baud rate to 9600
```

### HC-06 Setup (if needed)
```
AT Commands (connect at 9600 baud):
AT+NAMESmartBag        // Set device name
AT+PIN1234             // Set pairing password
```

## 🧪 Testing the Hardware

### Basic Power Test
1. Connect Arduino to USB
2. Upload a simple LED blink sketch
3. Verify Pin 13 LED blinks

### Bluetooth Test
1. Upload Arduino code
2. Open Serial Monitor at 9600 baud
3. Look for "Smart Bag Controller Initialized"
4. Check if Bluetooth module is discoverable

### Sensor Test
1. Monitor battery and temperature readings in Serial Monitor
2. Verify values are reasonable
3. Test servo movement with manual commands

### Integration Test
1. Pair mobile device with Bluetooth module
2. Connect with the mobile app
3. Test all functions: umbrella control, sensor readings, SMS setup

## 🔍 Troubleshooting

### Bluetooth Not Working
- Check wiring connections
- Verify baud rate (9600)
- Ensure module is powered
- Try AT commands to test module

### Servo Not Moving
- Check power supply (servo needs adequate current)
- Verify signal wire connection to Pin 9
- Test with simple servo sweep code

### Temperature Reading Wrong
- Check LM35 orientation
- Verify 5V power supply
- Check analog pin connection
- Calibrate if necessary

### Battery Reading Incorrect
- Verify voltage divider resistor values
- Check connections
- Calibrate in software

## ⚠️ Safety Notes

1. **Power Supply**: Don't exceed Arduino voltage ratings
2. **Current Draw**: Ensure power supply can handle total current
3. **Connections**: Double-check all wiring before powering on
4. **Servo Power**: Large servos may need separate power supply
5. **Battery**: Use appropriate battery protection circuits

## 📐 Mechanical Integration

### Umbrella Mechanism
- Mount servo securely to bag frame
- Connect servo arm to umbrella deployment mechanism
- Ensure smooth operation without binding
- Test range of motion safely

### Sensor Placement
- Mount temperature sensor in ventilated area
- Keep away from heat sources
- Protect from moisture if needed

### Enclosure
- Use weatherproof enclosure for electronics
- Ensure access to charging port
- Provide ventilation for heat dissipation
- Mount securely to bag

## 🔧 Advanced Modifications

### Power Optimization
- Use sleep modes for battery saving
- Add power switch for manual control
- Implement low-power Bluetooth modules

### Additional Sensors
- GPS module for location tracking
- Accelerometer for motion detection
- Light sensor for automatic lighting

### Communication Upgrades
- WiFi module for internet connectivity
- LoRa for long-range communication
- GSM module for SMS capabilities

---

**Note**: Always test individual components before final assembly. Take photos of your wiring for future reference.