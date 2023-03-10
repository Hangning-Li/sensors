import {
  accelerometer,
  gyroscope,
  setUpdateIntervalForType,
  SensorTypes
} from "react-native-sensors";
import { useState, useEffect } from "react";
import { View, StyleSheet, Text } from 'react-native';

import { NativeModules, NativeEventEmitter } from 'react-native';

const {BackgroundTaskManager} = NativeModules;

const SensorScreen = () => {
  const [accelerometerData, setAccelerometerData] = useState({});
  const [gyroscopeData, setGyroscopeData] = useState({});

  useEffect(() => {
    BackgroundTaskManager.start();

    const a_subscription = accelerometer.subscribe((accelerometerData) =>
      setAccelerometerData(accelerometerData)
    )

    const g_subscription = gyroscope.subscribe((gyroscopeData) =>
      setGyroscopeData(gyroscopeData)
    )

    setTimeout(() => {
      // If it's the last subscription to accelerometer it will stop polling in the native API
      g_subscription.unsubscribe();
      a_subscription.unsubscribe();
      BackgroundTaskManager.cancel();
    }, 1000);
    
    return () => {
      a_subscription.unsubscribe();
      g_subscription.unsubscribe();
      BackgroundTaskManager.cancel();
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Accelerometer Data</Text>
      <Text style={styles.data}>x: {accelerometerData.x}</Text>
      <Text style={styles.data}>y: {accelerometerData.y}</Text>
      <Text style={styles.data}>z: {accelerometerData.z}</Text>
      <Text style={styles.data}>time: {accelerometerData.timestamp}</Text>
      <Text style={styles.title}>Gyroscope Data</Text>
      <Text style={styles.data}>x: {gyroscopeData.x}</Text>
      <Text style={styles.data}>y: {gyroscopeData.y}</Text>
      <Text style={styles.data}>z: {gyroscopeData.z}</Text>
      <Text style={styles.data}>time: {accelerometerData.timestamp}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  title: {
    fontSize: 20,
    marginTop: 20,
  },
  data: {
    fontSize: 16,
    marginTop: 10,
  },
});

export default SensorScreen;