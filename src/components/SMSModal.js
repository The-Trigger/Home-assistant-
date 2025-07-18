import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  TextInput,
  Alert,
} from 'react-native';
import Modal from 'react-native-modal';
import LinearGradient from 'react-native-linear-gradient';

const SMSModal = ({ visible, onClose, onUpdate, currentNumber }) => {
  const [phoneNumber, setPhoneNumber] = useState('');
  const [isValid, setIsValid] = useState(false);

  useEffect(() => {
    if (visible) {
      setPhoneNumber(currentNumber || '');
      setIsValid(validatePhoneNumber(currentNumber || ''));
    }
  }, [visible, currentNumber]);

  const validatePhoneNumber = (number) => {
    // Basic phone number validation (can be customized for specific formats)
    const phoneRegex = /^[+]?[1-9][\d\s\-\(\)]{8,15}$/;
    return phoneRegex.test(number.replace(/\s/g, ''));
  };

  const handlePhoneNumberChange = (text) => {
    setPhoneNumber(text);
    setIsValid(validatePhoneNumber(text));
  };

  const handleSave = () => {
    if (!isValid) {
      Alert.alert('Invalid Number', 'Please enter a valid phone number.');
      return;
    }

    if (phoneNumber === currentNumber) {
      Alert.alert('No Changes', 'The phone number is the same as the current one.');
      return;
    }

    Alert.alert(
      'Update SMS Number',
      `Do you want to update the SMS number to ${phoneNumber}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Update', 
          onPress: () => onUpdate(phoneNumber)
        }
      ]
    );
  };

  const handleClear = () => {
    setPhoneNumber('');
    setIsValid(false);
  };

  const formatPhoneNumber = (text) => {
    // Remove all non-numeric characters except +
    const cleaned = text.replace(/[^\d+]/g, '');
    return cleaned;
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
          colors={['#673AB7', '#9C27B0']}
          style={styles.header}
        >
          <Text style={styles.title}>📱 SMS Configuration</Text>
          <TouchableOpacity style={styles.closeButton} onPress={onClose}>
            <Text style={styles.closeButtonText}>✕</Text>
          </TouchableOpacity>
        </LinearGradient>

        <View style={styles.content}>
          <Text style={styles.description}>
            Configure the SMS number for your Smart Bag notifications and alerts.
          </Text>

          {currentNumber && (
            <View style={styles.currentNumberContainer}>
              <Text style={styles.currentNumberLabel}>Current Number:</Text>
              <Text style={styles.currentNumber}>{currentNumber}</Text>
            </View>
          )}

          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>Phone Number</Text>
            <TextInput
              style={[
                styles.textInput,
                !isValid && phoneNumber.length > 0 && styles.invalidInput
              ]}
              value={phoneNumber}
              onChangeText={handlePhoneNumberChange}
              placeholder="Enter phone number (e.g., +1234567890)"
              placeholderTextColor="#999"
              keyboardType="phone-pad"
              maxLength={20}
            />
            
            {phoneNumber.length > 0 && (
              <View style={styles.validationContainer}>
                {isValid ? (
                  <Text style={styles.validText}>✅ Valid phone number</Text>
                ) : (
                  <Text style={styles.invalidText}>❌ Invalid phone number format</Text>
                )}
              </View>
            )}
          </View>

          <View style={styles.formatInfo}>
            <Text style={styles.formatTitle}>Supported Formats:</Text>
            <Text style={styles.formatExample}>• +1234567890</Text>
            <Text style={styles.formatExample}>• 1234567890</Text>
            <Text style={styles.formatExample}>• +1 (234) 567-890</Text>
          </View>

          <View style={styles.buttonContainer}>
            <TouchableOpacity
              style={styles.clearButton}
              onPress={handleClear}
            >
              <Text style={styles.clearButtonText}>Clear</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.saveButton,
                !isValid && styles.disabledButton
              ]}
              onPress={handleSave}
              disabled={!isValid}
            >
              <LinearGradient
                colors={isValid ? ['#4CAF50', '#45a049'] : ['#CCCCCC', '#CCCCCC']}
                style={styles.saveButtonGradient}
              >
                <Text style={styles.saveButtonText}>Update Number</Text>
              </LinearGradient>
            </TouchableOpacity>
          </View>
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
    overflow: 'hidden',
    maxHeight: '80%',
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
  description: {
    fontSize: 16,
    color: '#666',
    marginBottom: 20,
    lineHeight: 22,
  },
  currentNumberContainer: {
    backgroundColor: 'rgba(103, 58, 183, 0.1)',
    padding: 15,
    borderRadius: 10,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: 'rgba(103, 58, 183, 0.3)',
  },
  currentNumberLabel: {
    fontSize: 14,
    color: '#673AB7',
    fontWeight: 'bold',
    marginBottom: 5,
  },
  currentNumber: {
    fontSize: 16,
    color: '#333',
    fontWeight: '500',
  },
  inputContainer: {
    marginBottom: 20,
  },
  inputLabel: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  textInput: {
    borderWidth: 2,
    borderColor: '#E0E0E0',
    borderRadius: 10,
    padding: 15,
    fontSize: 16,
    color: '#333',
    backgroundColor: '#FAFAFA',
  },
  invalidInput: {
    borderColor: '#F44336',
    backgroundColor: 'rgba(244, 67, 54, 0.05)',
  },
  validationContainer: {
    marginTop: 8,
  },
  validText: {
    fontSize: 14,
    color: '#4CAF50',
    fontWeight: '500',
  },
  invalidText: {
    fontSize: 14,
    color: '#F44336',
    fontWeight: '500',
  },
  formatInfo: {
    backgroundColor: '#F5F5F5',
    padding: 15,
    borderRadius: 10,
    marginBottom: 20,
  },
  formatTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  formatExample: {
    fontSize: 12,
    color: '#666',
    marginBottom: 2,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  clearButton: {
    flex: 1,
    backgroundColor: '#F5F5F5',
    padding: 15,
    borderRadius: 10,
    marginRight: 10,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#E0E0E0',
  },
  clearButtonText: {
    color: '#666',
    fontSize: 16,
    fontWeight: 'bold',
  },
  saveButton: {
    flex: 2,
    borderRadius: 10,
    marginLeft: 10,
  },
  disabledButton: {
    opacity: 0.5,
  },
  saveButtonGradient: {
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
  },
  saveButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default SMSModal;