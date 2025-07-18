import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Dimensions,
  Image,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';

const { width, height } = Dimensions.get('window');

const AuthScreen = ({ onAuthenticate }) => {
  return (
    <LinearGradient
      colors={['#667eea', '#764ba2']}
      style={styles.container}
    >
      <Animatable.View 
        animation="fadeInDown" 
        duration={1000}
        style={styles.headerContainer}
      >
        <Text style={styles.title}>Smart Bag Controller</Text>
        <Text style={styles.subtitle}>Secure Access Required</Text>
      </Animatable.View>

      <Animatable.View 
        animation="pulse" 
        iterationCount="infinite"
        style={styles.fingerprintContainer}
      >
        <View style={styles.fingerprintCircle}>
          <Text style={styles.fingerprintIcon}>👆</Text>
        </View>
      </Animatable.View>

      <Animatable.View 
        animation="fadeInUp" 
        duration={1000}
        delay={500}
        style={styles.contentContainer}
      >
        <Text style={styles.description}>
          Use your fingerprint to unlock the Smart Bag Controller and access all features.
        </Text>

        <TouchableOpacity
          style={styles.authenticateButton}
          onPress={onAuthenticate}
          activeOpacity={0.8}
        >
          <LinearGradient
            colors={['#4CAF50', '#45a049']}
            style={styles.buttonGradient}
          >
            <Text style={styles.buttonText}>Authenticate</Text>
          </LinearGradient>
        </TouchableOpacity>

        <View style={styles.featuresContainer}>
          <Text style={styles.featuresTitle}>Features:</Text>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>☂️</Text>
            <Text style={styles.featureText}>Control umbrella open/close</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>🔋</Text>
            <Text style={styles.featureText}>Monitor battery level</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>🌡️</Text>
            <Text style={styles.featureText}>Temperature monitoring</Text>
          </View>
          <View style={styles.featureItem}>
            <Text style={styles.featureIcon}>📱</Text>
            <Text style={styles.featureText}>SMS number configuration</Text>
          </View>
        </View>
      </Animatable.View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  headerContainer: {
    alignItems: 'center',
    marginBottom: 50,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FFFFFF',
    textAlign: 'center',
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    color: '#E8EAF6',
    textAlign: 'center',
  },
  fingerprintContainer: {
    marginBottom: 50,
  },
  fingerprintCircle: {
    width: 120,
    height: 120,
    borderRadius: 60,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 2,
    borderColor: 'rgba(255, 255, 255, 0.3)',
  },
  fingerprintIcon: {
    fontSize: 60,
  },
  contentContainer: {
    alignItems: 'center',
    width: '100%',
  },
  description: {
    fontSize: 16,
    color: '#E8EAF6',
    textAlign: 'center',
    marginBottom: 30,
    lineHeight: 24,
  },
  authenticateButton: {
    width: '80%',
    marginBottom: 40,
    borderRadius: 25,
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  buttonGradient: {
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 25,
    alignItems: 'center',
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: 'bold',
  },
  featuresContainer: {
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    borderRadius: 15,
    padding: 20,
    width: '100%',
  },
  featuresTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 15,
    textAlign: 'center',
  },
  featureItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  featureIcon: {
    fontSize: 20,
    marginRight: 15,
    width: 30,
  },
  featureText: {
    fontSize: 14,
    color: '#E8EAF6',
    flex: 1,
  },
});

export default AuthScreen;