import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  RefreshControl,
  Dimensions,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';

import BluetoothService from '../services/BluetoothService';
import ConnectionModal from '../components/ConnectionModal';
import ControlCard from '../components/ControlCard';
import StatusCard from '../components/StatusCard';
import SMSModal from '../components/SMSModal';

const { width } = Dimensions.get('window');

const MainScreen = ({ isConnected, device, onConnect, onDisconnect }) => {
  const [batteryLevel, setBatteryLevel] = useState(0);
  const [temperature, setTemperature] = useState(0);
  const [umbrellaStatus, setUmbrellaStatus] = useState('CLOSED');
  const [smsNumber, setSmsNumber] = useState('');
  const [showConnectionModal, setShowConnectionModal] = useState(false);
  const [showSMSModal, setShowSMSModal] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (isConnected) {
      setupBluetoothListeners();
      requestAllData();
    }
    
    return () => {
      // Clean up listeners
      BluetoothService.off('batteryLevel', handleBatteryLevel);
      BluetoothService.off('temperature', handleTemperature);
      BluetoothService.off('umbrellaStatus', handleUmbrellaStatus);
      BluetoothService.off('smsResponse', handleSmsResponse);
    };
  }, [isConnected]);

  const setupBluetoothListeners = () => {
    BluetoothService.on('batteryLevel', handleBatteryLevel);
    BluetoothService.on('temperature', handleTemperature);
    BluetoothService.on('umbrellaStatus', handleUmbrellaStatus);
    BluetoothService.on('smsResponse', handleSmsResponse);
  };

  const handleBatteryLevel = (level) => {
    setBatteryLevel(level);
  };

  const handleTemperature = (temp) => {
    setTemperature(temp);
  };

  const handleUmbrellaStatus = (status) => {
    setUmbrellaStatus(status);
  };

  const handleSmsResponse = (response) => {
    if (response.startsWith('NUMBER:')) {
      setSmsNumber(response.replace('NUMBER:', ''));
    }
  };

  const requestAllData = async () => {
    if (!isConnected) return;
    
    try {
      await BluetoothService.requestBatteryLevel();
      await BluetoothService.requestTemperature();
      await BluetoothService.requestStatus();
      await BluetoothService.getSMSNumber();
    } catch (error) {
      console.log('Error requesting data:', error);
    }
  };

  const onRefresh = async () => {
    setRefreshing(true);
    await requestAllData();
    setRefreshing(false);
  };

  const handleUmbrellaControl = async (action) => {
    if (!isConnected) {
      Alert.alert('Not Connected', 'Please connect to your Smart Bag first.');
      return;
    }

    setLoading(true);
    try {
      if (action === 'open') {
        await BluetoothService.openUmbrella();
      } else {
        await BluetoothService.closeUmbrella();
      }
      // Request updated status
      setTimeout(() => {
        BluetoothService.requestStatus();
      }, 1000);
    } catch (error) {
      Alert.alert('Error', 'Failed to control umbrella: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSMSUpdate = async (newNumber) => {
    if (!isConnected) {
      Alert.alert('Not Connected', 'Please connect to your Smart Bag first.');
      return;
    }

    try {
      await BluetoothService.setSMSNumber(newNumber);
      Alert.alert('Success', 'SMS number updated successfully!');
      setShowSMSModal(false);
      // Request updated SMS number
      setTimeout(() => {
        BluetoothService.getSMSNumber();
      }, 1000);
    } catch (error) {
      Alert.alert('Error', 'Failed to update SMS number: ' + error.message);
    }
  };

  const getBatteryColor = () => {
    if (batteryLevel > 60) return '#4CAF50';
    if (batteryLevel > 30) return '#FF9800';
    return '#F44336';
  };

  const getTemperatureColor = () => {
    if (temperature < 10) return '#2196F3';
    if (temperature < 25) return '#4CAF50';
    if (temperature < 35) return '#FF9800';
    return '#F44336';
  };

  return (
    <LinearGradient colors={['#f5f7fa', '#c3cfe2']} style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.headerTitle}>Smart Bag Controller</Text>
          <TouchableOpacity
            style={[
              styles.connectionButton,
              { backgroundColor: isConnected ? '#4CAF50' : '#F44336' }
            ]}
            onPress={() => setShowConnectionModal(true)}
          >
            <Text style={styles.connectionButtonText}>
              {isConnected ? '🔗 Connected' : '📱 Connect'}
            </Text>
          </TouchableOpacity>
        </View>

        {isConnected && device && (
          <Animatable.View animation="fadeIn" style={styles.deviceInfo}>
            <Text style={styles.deviceName}>📱 {device.name}</Text>
            <Text style={styles.deviceAddress}>{device.address}</Text>
          </Animatable.View>
        )}

        {/* Status Cards */}
        <View style={styles.statusContainer}>
          <StatusCard
            icon="🔋"
            title="Battery Level"
            value={`${batteryLevel}%`}
            color={getBatteryColor()}
            subtitle={batteryLevel > 20 ? 'Good' : 'Low Battery'}
          />
          <StatusCard
            icon="🌡️"
            title="Temperature"
            value={`${temperature}°C`}
            color={getTemperatureColor()}
            subtitle={temperature < 25 ? 'Cool' : temperature < 35 ? 'Warm' : 'Hot'}
          />
        </View>

        {/* Umbrella Control */}
        <ControlCard
          title="☂️ Umbrella Control"
          subtitle={`Status: ${umbrellaStatus}`}
        >
          <View style={styles.umbrellaControls}>
            <TouchableOpacity
              style={[
                styles.controlButton,
                { backgroundColor: umbrellaStatus === 'OPEN' ? '#4CAF50' : '#2196F3' }
              ]}
              onPress={() => handleUmbrellaControl('open')}
              disabled={loading || !isConnected}
            >
              <Text style={styles.controlButtonText}>
                {loading && umbrellaStatus !== 'OPEN' ? '⏳' : '☂️'}
              </Text>
              <Text style={styles.controlButtonLabel}>Open</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.controlButton,
                { backgroundColor: umbrellaStatus === 'CLOSED' ? '#4CAF50' : '#FF5722' }
              ]}
              onPress={() => handleUmbrellaControl('close')}
              disabled={loading || !isConnected}
            >
              <Text style={styles.controlButtonText}>
                {loading && umbrellaStatus !== 'CLOSED' ? '⏳' : '🌂'}
              </Text>
              <Text style={styles.controlButtonLabel}>Close</Text>
            </TouchableOpacity>
          </View>
        </ControlCard>

        {/* SMS Configuration */}
        <ControlCard
          title="📱 SMS Configuration"
          subtitle={smsNumber ? `Current: ${smsNumber}` : 'Not configured'}
        >
          <TouchableOpacity
            style={styles.smsConfigButton}
            onPress={() => setShowSMSModal(true)}
            disabled={!isConnected}
          >
            <LinearGradient
              colors={['#673AB7', '#9C27B0']}
              style={styles.smsButtonGradient}
            >
              <Text style={styles.smsButtonText}>Configure SMS Number</Text>
            </LinearGradient>
          </TouchableOpacity>
        </ControlCard>

        {/* Quick Actions */}
        <ControlCard title="⚡ Quick Actions" subtitle="Instant controls">
          <View style={styles.quickActions}>
            <TouchableOpacity
              style={styles.quickActionButton}
              onPress={requestAllData}
              disabled={!isConnected}
            >
              <Text style={styles.quickActionIcon}>🔄</Text>
              <Text style={styles.quickActionText}>Refresh</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.quickActionButton}
              onPress={onDisconnect}
              disabled={!isConnected}
            >
              <Text style={styles.quickActionIcon}>🔌</Text>
              <Text style={styles.quickActionText}>Disconnect</Text>
            </TouchableOpacity>
          </View>
        </ControlCard>

        <View style={styles.bottomPadding} />
      </ScrollView>

      <ConnectionModal
        visible={showConnectionModal}
        onClose={() => setShowConnectionModal(false)}
        onConnect={onConnect}
        isConnected={isConnected}
        currentDevice={device}
        onDisconnect={onDisconnect}
      />

      <SMSModal
        visible={showSMSModal}
        onClose={() => setShowSMSModal(false)}
        onUpdate={handleSMSUpdate}
        currentNumber={smsNumber}
      />
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    paddingTop: 40,
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
  },
  connectionButton: {
    paddingHorizontal: 15,
    paddingVertical: 8,
    borderRadius: 20,
  },
  connectionButtonText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  deviceInfo: {
    backgroundColor: 'rgba(76, 175, 80, 0.1)',
    margin: 20,
    marginTop: 0,
    padding: 15,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(76, 175, 80, 0.3)',
  },
  deviceName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
  },
  deviceAddress: {
    fontSize: 12,
    color: '#666',
    marginTop: 2,
  },
  statusContainer: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  umbrellaControls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginTop: 15,
  },
  controlButton: {
    width: 80,
    height: 80,
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  controlButtonText: {
    fontSize: 24,
    marginBottom: 5,
  },
  controlButtonLabel: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
  smsConfigButton: {
    marginTop: 15,
    borderRadius: 25,
  },
  smsButtonGradient: {
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 25,
    alignItems: 'center',
  },
  smsButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
  },
  quickActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginTop: 15,
  },
  quickActionButton: {
    alignItems: 'center',
    padding: 15,
    backgroundColor: 'rgba(33, 150, 243, 0.1)',
    borderRadius: 10,
    minWidth: 80,
  },
  quickActionIcon: {
    fontSize: 24,
    marginBottom: 5,
  },
  quickActionText: {
    fontSize: 12,
    color: '#333',
    fontWeight: '500',
  },
  bottomPadding: {
    height: 20,
  },
});

export default MainScreen;