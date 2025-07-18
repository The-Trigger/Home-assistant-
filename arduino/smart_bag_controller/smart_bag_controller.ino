/*
  Smart Bag Controller
  Features:
  - Umbrella control (open/close)
  - Battery level monitoring
  - Temperature monitoring
  - SMS number configuration
  - Bluetooth communication with mobile app
*/

#include <SoftwareSerial.h>
#include <Servo.h>
#include <EEPROM.h>

// Pin definitions
#define BLUETOOTH_RX_PIN 2
#define BLUETOOTH_TX_PIN 3
#define UMBRELLA_SERVO_PIN 9
#define BATTERY_PIN A0
#define TEMP_SENSOR_PIN A1
#define LED_PIN 13

// Servo for umbrella control
Servo umbrellaServo;

// Bluetooth communication
SoftwareSerial bluetooth(BLUETOOTH_RX_PIN, BLUETOOTH_TX_PIN);

// Umbrella positions
#define UMBRELLA_CLOSED_POS 0
#define UMBRELLA_OPEN_POS 180

// EEPROM addresses
#define SMS_NUMBER_ADDR 0
#define SMS_NUMBER_SIZE 20

// Global variables
String smsNumber = "";
int batteryLevel = 0;
float temperature = 0.0;
String umbrellaStatus = "CLOSED";
unsigned long lastSensorRead = 0;
const unsigned long SENSOR_INTERVAL = 5000; // Read sensors every 5 seconds

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);
  
  pinMode(LED_PIN, OUTPUT);
  pinMode(BATTERY_PIN, INPUT);
  pinMode(TEMP_SENSOR_PIN, INPUT);
  
  // Initialize servo
  umbrellaServo.attach(UMBRELLA_SERVO_PIN);
  umbrellaServo.write(UMBRELLA_CLOSED_POS);
  
  // Load SMS number from EEPROM
  loadSMSNumber();
  
  // Initial sensor readings
  readSensors();
  
  Serial.println("Smart Bag Controller Initialized");
  sendStatus("READY");
  
  // Blink LED to indicate startup
  for(int i = 0; i < 3; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(200);
    digitalWrite(LED_PIN, LOW);
    delay(200);
  }
}

void loop() {
  // Handle Bluetooth commands
  if (bluetooth.available()) {
    String command = bluetooth.readStringUntil('\n');
    command.trim();
    handleCommand(command);
  }
  
  // Read sensors periodically
  if (millis() - lastSensorRead >= SENSOR_INTERVAL) {
    readSensors();
    lastSensorRead = millis();
    
    // Send battery level if it's low (below 20%)
    if (batteryLevel < 20) {
      sendData("BATTERY", String(batteryLevel));
      blinkWarning();
    }
  }
  
  delay(100);
}

void handleCommand(String command) {
  Serial.println("Received command: " + command);
  
  int colonIndex = command.indexOf(':');
  String cmd = "";
  String data = "";
  
  if (colonIndex != -1) {
    cmd = command.substring(0, colonIndex);
    data = command.substring(colonIndex + 1);
  } else {
    cmd = command;
  }
  
  cmd.toUpperCase();
  
  if (cmd == "UMBRELLA") {
    handleUmbrellaCommand(data);
  }
  else if (cmd == "GET_BATTERY") {
    sendData("BATTERY", String(batteryLevel));
  }
  else if (cmd == "GET_TEMP") {
    sendData("TEMP", String(temperature));
  }
  else if (cmd == "GET_STATUS") {
    sendAllStatus();
  }
  else if (cmd == "SET_SMS") {
    setSMSNumber(data);
  }
  else if (cmd == "GET_SMS") {
    sendData("SMS", "NUMBER:" + smsNumber);
  }
  else {
    sendStatus("UNKNOWN_COMMAND");
  }
}

void handleUmbrellaCommand(String action) {
  action.toUpperCase();
  
  if (action == "OPEN") {
    openUmbrella();
  } else if (action == "CLOSE") {
    closeUmbrella();
  } else {
    sendStatus("INVALID_UMBRELLA_ACTION");
  }
}

void openUmbrella() {
  Serial.println("Opening umbrella...");
  
  // Smooth servo movement
  int currentPos = umbrellaServo.read();
  for (int pos = currentPos; pos <= UMBRELLA_OPEN_POS; pos += 2) {
    umbrellaServo.write(pos);
    delay(20);
  }
  
  umbrellaStatus = "OPEN";
  sendData("UMBRELLA", umbrellaStatus);
  sendStatus("UMBRELLA_OPENED");
  
  // Visual feedback
  digitalWrite(LED_PIN, HIGH);
  delay(1000);
  digitalWrite(LED_PIN, LOW);
}

void closeUmbrella() {
  Serial.println("Closing umbrella...");
  
  // Smooth servo movement
  int currentPos = umbrellaServo.read();
  for (int pos = currentPos; pos >= UMBRELLA_CLOSED_POS; pos -= 2) {
    umbrellaServo.write(pos);
    delay(20);
  }
  
  umbrellaStatus = "CLOSED";
  sendData("UMBRELLA", umbrellaStatus);
  sendStatus("UMBRELLA_CLOSED");
  
  // Visual feedback
  for(int i = 0; i < 2; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(200);
    digitalWrite(LED_PIN, LOW);
    delay(200);
  }
}

void readSensors() {
  // Read battery level (0-100%)
  int batteryReading = analogRead(BATTERY_PIN);
  batteryLevel = map(batteryReading, 0, 1023, 0, 100);
  
  // Read temperature sensor (LM35 or similar)
  int tempReading = analogRead(TEMP_SENSOR_PIN);
  float voltage = (tempReading * 5.0) / 1024.0;
  temperature = voltage * 100.0; // For LM35: 10mV per degree Celsius
  
  Serial.print("Battery: ");
  Serial.print(batteryLevel);
  Serial.print("%, Temperature: ");
  Serial.print(temperature);
  Serial.println("°C");
}

void setSMSNumber(String number) {
  number.trim();
  if (number.length() > 0 && number.length() <= SMS_NUMBER_SIZE - 1) {
    smsNumber = number;
    saveSMSNumber();
    sendData("SMS", "UPDATED:" + smsNumber);
    sendStatus("SMS_NUMBER_UPDATED");
    Serial.println("SMS number updated: " + smsNumber);
  } else {
    sendStatus("INVALID_SMS_NUMBER");
  }
}

void saveSMSNumber() {
  // Clear EEPROM area first
  for (int i = 0; i < SMS_NUMBER_SIZE; i++) {
    EEPROM.write(SMS_NUMBER_ADDR + i, 0);
  }
  
  // Write SMS number to EEPROM
  for (int i = 0; i < smsNumber.length(); i++) {
    EEPROM.write(SMS_NUMBER_ADDR + i, smsNumber.charAt(i));
  }
}

void loadSMSNumber() {
  smsNumber = "";
  for (int i = 0; i < SMS_NUMBER_SIZE; i++) {
    char c = EEPROM.read(SMS_NUMBER_ADDR + i);
    if (c == 0) break;
    smsNumber += c;
  }
  
  if (smsNumber.length() > 0) {
    Serial.println("Loaded SMS number: " + smsNumber);
  } else {
    Serial.println("No SMS number stored");
  }
}

void sendData(String dataType, String value) {
  String message = dataType + ":" + value;
  bluetooth.println(message);
  Serial.println("Sent: " + message);
}

void sendStatus(String status) {
  sendData("STATUS", status);
}

void sendAllStatus() {
  sendData("BATTERY", String(batteryLevel));
  sendData("TEMP", String(temperature));
  sendData("UMBRELLA", umbrellaStatus);
  if (smsNumber.length() > 0) {
    sendData("SMS", "NUMBER:" + smsNumber);
  }
}

void blinkWarning() {
  // Warning blink pattern for low battery
  for(int i = 0; i < 5; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(100);
    digitalWrite(LED_PIN, LOW);
    delay(100);
  }
}

// Emergency functions
void emergencyStop() {
  // Stop all motors and return to safe state
  umbrellaServo.write(UMBRELLA_CLOSED_POS);
  umbrellaStatus = "CLOSED";
  sendStatus("EMERGENCY_STOP");
}

// Utility function to handle serial commands for testing
void handleSerialCommand() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    
    // Mirror command to bluetooth for testing
    bluetooth.println(command);
    handleCommand(command);
  }
}