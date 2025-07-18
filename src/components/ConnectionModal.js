import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  FlatList,
  Alert,
  ActivityIndicator,
} from 'react-native';
import Modal from 'react-native-modal';
import LinearGradient from 'react-native-linear-gradient';

import BluetoothService from '../services/BluetoothService';

const ConnectionModal = ({ 
  visible, 
  onClose, 
  onConnect, 
  isConnected, 
  currentDevice, 
  onDisconnect 
}) => {
  const [devices, setDevices] = useState([]);
  const [loading, setLoading] = useState(false);
  const [scanning, setScanning] = useState(false);

  useEffect(() => {
    if (visible) {
      loadDevices();
    }
  }, [visible]);

  const loadDevices = async () => {
    setLoading(true);
    try {
      const bondedDevices = await BluetoothService.getAvailableDevices();
      setDevices(bondedDevices);
    } catch (error) {
      Alert.alert('Error', 'Failed to load devices: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const scanForDevices = async () => {
    setScanning(true);
    try {
      const discoveredDevices = await BluetoothService.discoverDevices();
      // Combine bonded and discovered devices
      const allDevices = [...devices];
      discoveredDevices.forEach(device => {
        if (!allDevices.find(d => d.id === device.id)) {
          allDevices.push(device);
        }
      });
      setDevices(allDevices);
    } catch (error) {
      Alert.alert('Error', 'Failed to scan for devices: ' + error.message);
    } finally {
      setScanning(false);
    }
  };

  const handleDeviceSelect = (device) => {
    Alert.alert(
      'Connect to Device',
      `Do you want to connect to ${device.name}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Connect', 
          onPress: () => {
            onConnect(device);
            onClose();
          }
        }
      ]
    );
  };

  const handleDisconnect = () => {
    Alert.alert(
      'Disconnect Device',
      'Are you sure you want to disconnect?',
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Disconnect', 
          onPress: () => {
            onDisconnect();
            onClose();
          }
        }
      ]
    );
  };

  const renderDevice = ({ item }) => {
    const isCurrentDevice = currentDevice && currentDevice.id === item.id;
    
    return (
      <TouchableOpacity
        style={[
          styles.deviceItem,
          isCurrentDevice && styles.connectedDevice
        ]}
        onPress={() => handleDeviceSelect(item)}
        disabled={isCurrentDevice && isConnected}
      >
        <View style={styles.deviceInfo}>
          <Text style={styles.deviceName}>
            {isCurrentDevice ? '🔗 ' : '📱 '}
            {item.name || 'Unknown Device'}
          </Text>
          <Text style={styles.deviceAddress}>{item.address}</Text>
          {item.bonded && (
            <Text style={styles.bondedLabel}>Paired</Text>
          )}
        </View>
        
        {isCurrentDevice && isConnected ? (
          <TouchableOpacity
            style={styles.disconnectButton}
            onPress={handleDisconnect}
          >
            <Text style={styles.disconnectButtonText}>Disconnect</Text>
          </TouchableOpacity>
        ) : (
          <View style={styles.connectButton}>
            <Text style={styles.connectButtonText}>Connect</Text>
          </View>
        )}
      </TouchableOpacity>
    );
  };

  return (
    <Modal
      isVisible={visible}
      onBackdropPress={onClose}
      onBackButtonPress={onClose}
      style={styles.modal}
    >
      <View style={styles.container}>
        <LinearGradient
          colors={['#667eea', '#764ba2']}
          style={styles.header}
        >
          <Text style={styles.title}>Bluetooth Devices</Text>
          <TouchableOpacity style={styles.closeButton} onPress={onClose}>
            <Text style={styles.closeButtonText}>✕</Text>
          </TouchableOpacity>
        </LinearGradient>

        <View style={styles.content}>
          {isConnected && currentDevice && (
            <View style={styles.currentDeviceInfo}>
              <Text style={styles.currentDeviceTitle}>Currently Connected:</Text>
              <Text style={styles.currentDeviceName}>
                🔗 {currentDevice.name}
              </Text>
            </View>
          )}

          <View style={styles.actions}>
            <TouchableOpacity
              style={styles.refreshButton}
              onPress={loadDevices}
              disabled={loading}
            >
              <Text style={styles.actionButtonText}>
                {loading ? '⏳ Loading...' : '🔄 Refresh'}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.scanButton}
              onPress={scanForDevices}
              disabled={scanning}
            >
              <Text style={styles.actionButtonText}>
                {scanning ? '⏳ Scanning...' : '🔍 Scan'}
              </Text>
            </TouchableOpacity>
          </View>

          {loading ? (
            <View style={styles.loadingContainer}>
              <ActivityIndicator size="large" color="#667eea" />
              <Text style={styles.loadingText}>Loading devices...</Text>
            </View>
          ) : (
            <FlatList
              data={devices}
              renderItem={renderDevice}
              keyExtractor={(item) => item.id}
              style={styles.deviceList}
              showsVerticalScrollIndicator={false}
              ListEmptyComponent={
                <View style={styles.emptyContainer}>
                  <Text style={styles.emptyText}>No devices found</Text>
                  <Text style={styles.emptySubtext}>
                    Make sure Bluetooth is enabled and devices are paired
                  </Text>
                </View>
              }
            />
          )}
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  modal: {
    margin: 20,
  },
  container: {
    backgroundColor: '#FFFFFF',
    borderRadius: 15,
    maxHeight: '80%',
    overflow: 'hidden',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  closeButton: {
    width: 30,
    height: 30,
    borderRadius: 15,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  closeButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
  },
  content: {
    padding: 20,
  },
  currentDeviceInfo: {
    backgroundColor: 'rgba(76, 175, 80, 0.1)',
    padding: 15,
    borderRadius: 10,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: 'rgba(76, 175, 80, 0.3)',
  },
  currentDeviceTitle: {
    fontSize: 14,
    color: '#4CAF50',
    fontWeight: 'bold',
    marginBottom: 5,
  },
  currentDeviceName: {
    fontSize: 16,
    color: '#333',
  },
  actions: {
    flexDirection: 'row',
    marginBottom: 20,
  },
  refreshButton: {
    flex: 1,
    backgroundColor: '#2196F3',
    padding: 12,
    borderRadius: 8,
    marginRight: 10,
    alignItems: 'center',
  },
  scanButton: {
    flex: 1,
    backgroundColor: '#FF9800',
    padding: 12,
    borderRadius: 8,
    marginLeft: 10,
    alignItems: 'center',
  },
  actionButtonText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  loadingContainer: {
    alignItems: 'center',
    padding: 40,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666',
  },
  deviceList: {
    maxHeight: 300,
  },
  deviceItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 15,
    backgroundColor: '#F5F5F5',
    borderRadius: 10,
    marginBottom: 10,
  },
  connectedDevice: {
    backgroundColor: 'rgba(76, 175, 80, 0.1)',
    borderWidth: 1,
    borderColor: 'rgba(76, 175, 80, 0.3)',
  },
  deviceInfo: {
    flex: 1,
  },
  deviceName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 4,
  },
  deviceAddress: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  bondedLabel: {
    fontSize: 10,
    color: '#4CAF50',
    fontWeight: 'bold',
  },
  connectButton: {
    backgroundColor: '#2196F3',
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 5,
  },
  connectButtonText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  disconnectButton: {
    backgroundColor: '#F44336',
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 5,
  },
  disconnectButtonText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  emptyContainer: {
    alignItems: 'center',
    padding: 40,
  },
  emptyText: {
    fontSize: 18,
    color: '#666',
    marginBottom: 10,
  },
  emptySubtext: {
    fontSize: 14,
    color: '#999',
    textAlign: 'center',
  },
});

export default ConnectionModal;