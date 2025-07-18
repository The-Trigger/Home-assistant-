import BluetoothClassic from 'react-native-bluetooth-classic';

class BluetoothService {
  constructor() {
    this.device = null;
    this.isConnected = false;
  }

  // Connect to Arduino device
  async connectToDevice(device) {
    try {
      console.log('Attempting to connect to device:', device.name);
      
      // Check if already connected
      if (this.device && this.isConnected) {
        await this.disconnect();
      }

      const connected = await device.connect({
        delimiter: '\n',
        deviceEncoding: 'utf-8',
      });

      if (connected) {
        this.device = device;
        this.isConnected = true;
        
        // Set up data listener
        this.device.onDataReceived((data) => {
          this.handleDataReceived(data.data);
        });

        console.log('Successfully connected to device');
        return true;
      }
      return false;
    } catch (error) {
      console.error('Connection error:', error);
      this.isConnected = false;
      throw error;
    }
  }

  // Disconnect from device
  async disconnect() {
    try {
      if (this.device && this.isConnected) {
        await this.device.disconnect();
        this.device = null;
        this.isConnected = false;
        console.log('Disconnected from device');
      }
    } catch (error) {
      console.error('Disconnect error:', error);
      throw error;
    }
  }

  // Send command to Arduino
  async sendCommand(command, data = '') {
    if (!this.isConnected || !this.device) {
      throw new Error('Device not connected');
    }

    try {
      const message = `${command}:${data}\n`;
      await this.device.write(message);
      console.log('Sent command:', message.trim());
      return true;
    } catch (error) {
      console.error('Send command error:', error);
      throw error;
    }
  }

  // Handle incoming data from Arduino
  handleDataReceived(data) {
    console.log('Received data:', data);
    
    try {
      const message = data.trim();
      const [command, value] = message.split(':');
      
      // Emit events based on received data
      switch (command) {
        case 'BATTERY':
          this.emit('batteryLevel', parseInt(value));
          break;
        case 'TEMP':
          this.emit('temperature', parseFloat(value));
          break;
        case 'STATUS':
          this.emit('status', value);
          break;
        case 'UMBRELLA':
          this.emit('umbrellaStatus', value);
          break;
        case 'SMS':
          this.emit('smsResponse', value);
          break;
        default:
          this.emit('data', message);
      }
    } catch (error) {
      console.error('Error parsing received data:', error);
    }
  }

  // Event emitter functionality
  emit(event, data) {
    if (this.listeners && this.listeners[event]) {
      this.listeners[event].forEach(callback => callback(data));
    }
  }

  on(event, callback) {
    if (!this.listeners) {
      this.listeners = {};
    }
    if (!this.listeners[event]) {
      this.listeners[event] = [];
    }
    this.listeners[event].push(callback);
  }

  off(event, callback) {
    if (this.listeners && this.listeners[event]) {
      this.listeners[event] = this.listeners[event].filter(cb => cb !== callback);
    }
  }

  // Smart bag control commands
  async openUmbrella() {
    return await this.sendCommand('UMBRELLA', 'OPEN');
  }

  async closeUmbrella() {
    return await this.sendCommand('UMBRELLA', 'CLOSE');
  }

  async requestBatteryLevel() {
    return await this.sendCommand('GET_BATTERY');
  }

  async requestTemperature() {
    return await this.sendCommand('GET_TEMP');
  }

  async setSMSNumber(phoneNumber) {
    return await this.sendCommand('SET_SMS', phoneNumber);
  }

  async getSMSNumber() {
    return await this.sendCommand('GET_SMS');
  }

  async requestStatus() {
    return await this.sendCommand('GET_STATUS');
  }

  // Get list of available devices
  static async getAvailableDevices() {
    try {
      const isEnabled = await BluetoothClassic.isBluetoothEnabled();
      if (!isEnabled) {
        await BluetoothClassic.requestBluetoothEnabled();
      }

      const bondedDevices = await BluetoothClassic.getBondedDevices();
      return bondedDevices;
    } catch (error) {
      console.error('Error getting devices:', error);
      throw error;
    }
  }

  // Discover new devices
  static async discoverDevices() {
    try {
      const isEnabled = await BluetoothClassic.isBluetoothEnabled();
      if (!isEnabled) {
        await BluetoothClassic.requestBluetoothEnabled();
      }

      return await BluetoothClassic.startDiscovery();
    } catch (error) {
      console.error('Error discovering devices:', error);
      throw error;
    }
  }
}

export default new BluetoothService();