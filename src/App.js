import React, {useState, useEffect} from 'react';
import {
  StatusBar,
  StyleSheet,
  Alert,
  PermissionsAndroid,
  Platform,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import BluetoothClassic from 'react-native-bluetooth-classic';
import TouchID from 'react-native-touch-id';

import AuthScreen from './screens/AuthScreen';
import MainScreen from './screens/MainScreen';
import BluetoothService from './services/BluetoothService';

const App = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [device, setDevice] = useState(null);

  useEffect(() => {
    initializeApp();
  }, []);

  const initializeApp = async () => {
    await requestBluetoothPermissions();
    await checkSavedDevice();
  };

  const requestBluetoothPermissions = async () => {
    if (Platform.OS === 'android') {
      try {
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_SCAN,
          PermissionsAndroid.PERMISSIONS.BLUETOOTH_CONNECT,
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        ]);
        
        if (
          granted['android.permission.BLUETOOTH_SCAN'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.BLUETOOTH_CONNECT'] === PermissionsAndroid.RESULTS.GRANTED &&
          granted['android.permission.ACCESS_FINE_LOCATION'] === PermissionsAndroid.RESULTS.GRANTED
        ) {
          console.log('Bluetooth permissions granted');
        } else {
          Alert.alert('Permission Denied', 'Bluetooth permissions are required for this app to work.');
        }
      } catch (err) {
        console.warn(err);
      }
    }
  };

  const checkSavedDevice = async () => {
    try {
      const savedDeviceId = await AsyncStorage.getItem('connectedDevice');
      if (savedDeviceId) {
        const devices = await BluetoothClassic.getBondedDevices();
        const savedDevice = devices.find(d => d.id === savedDeviceId);
        if (savedDevice) {
          setDevice(savedDevice);
          try {
            const connected = await BluetoothService.connectToDevice(savedDevice);
            setIsConnected(connected);
          } catch (error) {
            console.log('Failed to auto-connect to saved device:', error);
          }
        }
      }
    } catch (error) {
      console.log('Error checking saved device:', error);
    }
  };

  const authenticateUser = async () => {
    try {
      const biometryType = await TouchID.isSupported();
      if (biometryType) {
        const isAuthenticated = await TouchID.authenticate('Unlock Smart Bag Controller', {
          showPopup: true,
          fallbackLabel: 'Use Passcode',
        });
        if (isAuthenticated) {
          setIsAuthenticated(true);
        }
      } else {
        Alert.alert(
          'Biometric Authentication',
          'Biometric authentication is not available on this device.',
          [
            { text: 'Continue Anyway', onPress: () => setIsAuthenticated(true) },
            { text: 'Cancel', style: 'cancel' }
          ]
        );
      }
    } catch (error) {
      console.log('Authentication error:', error);
      Alert.alert('Authentication Failed', 'Please try again or use alternative authentication.');
    }
  };

  const handleDeviceConnection = async (selectedDevice) => {
    try {
      const connected = await BluetoothService.connectToDevice(selectedDevice);
      if (connected) {
        setDevice(selectedDevice);
        setIsConnected(true);
        await AsyncStorage.setItem('connectedDevice', selectedDevice.id);
        Alert.alert('Success', 'Connected to Smart Bag successfully!');
      } else {
        Alert.alert('Connection Failed', 'Could not connect to the device. Please try again.');
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to connect to device: ' + error.message);
    }
  };

  const handleDisconnect = async () => {
    try {
      await BluetoothService.disconnect();
      setIsConnected(false);
      setDevice(null);
      await AsyncStorage.removeItem('connectedDevice');
    } catch (error) {
      console.log('Disconnect error:', error);
    }
  };

  if (!isAuthenticated) {
    return <AuthScreen onAuthenticate={authenticateUser} />;
  }

  return (
    <>
      <StatusBar barStyle="dark-content" backgroundColor="#2196F3" />
      <MainScreen
        isConnected={isConnected}
        device={device}
        onConnect={handleDeviceConnection}
        onDisconnect={handleDisconnect}
      />
    </>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default App;