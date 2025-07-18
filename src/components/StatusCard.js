import React from 'react';
import { View, Text, StyleSheet, Dimensions } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';

const { width } = Dimensions.get('window');

const StatusCard = ({ icon, title, value, color, subtitle }) => {
  return (
    <Animatable.View 
      animation="fadeInUp" 
      duration={800}
      style={styles.container}
    >
      <LinearGradient
        colors={['#FFFFFF', '#F8F9FA']}
        style={styles.card}
      >
        <View style={styles.iconContainer}>
          <Text style={styles.icon}>{icon}</Text>
        </View>
        
        <Text style={styles.title}>{title}</Text>
        
        <Text style={[styles.value, { color }]}>{value}</Text>
        
        <View style={[styles.indicator, { backgroundColor: color }]} />
        
        <Text style={styles.subtitle}>{subtitle}</Text>
      </LinearGradient>
    </Animatable.View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginHorizontal: 5,
  },
  card: {
    padding: 20,
    borderRadius: 15,
    alignItems: 'center',
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    borderWidth: 1,
    borderColor: 'rgba(0, 0, 0, 0.05)',
  },
  iconContainer: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: 'rgba(33, 150, 243, 0.1)',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  icon: {
    fontSize: 24,
  },
  title: {
    fontSize: 12,
    color: '#666',
    marginBottom: 8,
    textAlign: 'center',
  },
  value: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  indicator: {
    width: 30,
    height: 4,
    borderRadius: 2,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 10,
    color: '#999',
    textAlign: 'center',
  },
});

export default StatusCard;