import {
  accelerometer,
  gyroscope,
  setUpdateIntervalForType,
  SensorTypes
} from "react-native-sensors";
import { useState, useEffect, Component } from "react";
import { View, StyleSheet, Text } from 'react-native';

// import { NativeModules, NativeEventEmitter, DeviceEventEmitter } from 'react-native';
import BackgroundFetch from 'react-native-background-fetch';

const id = "com.hangning.sensorReading";

const SensorScreen = () => {

  const [accelerometerData, setAccelerometerData] = useState({});
  const [gyroscopeData, setGyroscopeData] = useState({});

  // Start the background worker
  const initBackgroundFetch = async () => {

    const status = await BackgroundFetch.configure({
      minimumFetchInterval: 15, // 15 minutes
      //Android options
      forceAlarmManager: false,     // <-- Set true to bypass JobScheduler.
      stopOnTerminate: false,
      startOnBoot: true,
      requiredNetworkType: BackgroundFetch.NETWORK_TYPE_NONE, // Default
      requiresCharging: false,      // Default
      requiresDeviceIdle: false,    // Default
      requiresBatteryNotLow: false, // Default
      requiresStorageNotLow: false  // Default 
    },  async () => {
      console.log('- BackgroundFetch start');
      let a_subscription = accelerometer.subscribe((accelerometerData) => {
        setAccelerometerData(accelerometerData);
        console.log('- BackgroundFetch accelerometer: ', accelerometerData);
      })
      // console.log('- BackgroundFetch accelerometer: ', ) // <-- don't see this
      // console.log('- BackgroundFetch gyroscope: ', ) // <-- don't see this
      BackgroundFetch.finish(id);
    }, (error) => {
      console.log('[js] RNBackgroundFetch failed to start')
    });

    console.log('[ RNBF STATUS ]', status)

  }

  

  // handleTask is called periodically when RNBF triggers an event
  const handleTask = async (taskId) => {

    console.log('[ RNBF TASK ID ]', taskId)

    // DO BACKGROUND WORK HERE
    const a_subscription = accelerometer.subscribe((accelerometerData) => {
      setAccelerometerData(accelerometerData);
      // console.log(accelerometerData);
    })
    const g_subscription = gyroscope.subscribe((gyroscopeData) => {
      setAccelerometerData(gyroscopeData);
      // console.log(gyroscopeData);
    })

    // This MUST be called in order to signal to the OS that your task is complete
    BackgroundFetch.finish(taskId)

  }

  const onTimeout = async () => {

    // The timeout function is called when the OS signals that the task has reached its maximum execution time.

    // ADD CLEANUP WORK HERE (IF NEEDED)

    BackgroundFetch.finish(id)

  }


  useEffect(() => {
    initBackgroundFetch()

    BackgroundFetch.scheduleTask({
      taskId: id,
      delay: 60 * 2 * 1000 //  two minutes (milliseconds)
    });
    

    BackgroundFetch.start();

    const a_subscription = accelerometer.subscribe((accelerometerData) =>
      setAccelerometerData(accelerometerData)
    )

    const g_subscription = gyroscope.subscribe((gyroscopeData) =>
      setGyroscopeData(gyroscopeData)
    )

    console.log(BackgroundFetch.status);

    setTimeout(() => {
      BackgroundFetch.stop(id);
      g_subscription.unsubscribe();
      a_subscription.unsubscribe();
      // BackgroundTaskManager.cancel();
    }, 1000);

    return () => {
      a_subscription.unsubscribe();
      g_subscription.unsubscribe();
      // BackgroundTaskManager.cancel();
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