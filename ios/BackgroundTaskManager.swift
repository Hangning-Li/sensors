//
//  BackgroundTaskManager.swift
//  sensors
//
//  Created by Hangning Li on 2023-03-03.
//

import Foundation
import UIKit
import BackgroundTasks
import CoreMotion
import OSLog

@objc(BackgroundTaskManager)
class BackgroundTaskManager : NSObject {
  let backgroundTaskIdentifier = "com.hangning.sensorReading";
  
  let motionManager = CMMotionManager();
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc
  func startReading(){
    if #available(iOS 14.0, *) {
      Logger().info("reading started")
    }
  }
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Register background task
      registerBackgroundTask()
        
      if #available(iOS 14.0, *) {
        Logger().info("[BGTASK] Perform bg processing \(self.backgroundTaskIdentifier)")
      }
    
      return true
  }
  
  @available(iOS 13.0, *)
  func applicationDidEnterBackground(_ application: UIApplication) {
    scheduleBackgroundProcessing()
    print("App did enter background")
    if #available(iOS 14.0, *) {
      Logger().info("App did enter background")
    }
  }
  
  @objc
  func cancel() {
    motionManager.stopAccelerometerUpdates()
    motionManager.stopGyroUpdates()
    BGTaskScheduler.shared.cancelAllTaskRequests()
  }
  
  @available(iOS 13.0, *)
  func registerBackgroundTask() {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
      // Handle the task
      // Create a motion manager
      // Set up the accelerometer
      self.motionManager.accelerometerUpdateInterval = 0.1 // Update interval in seconds
      self.motionManager.gyroUpdateInterval = 0.1
      
      //      if motionManager.isAccelerometerAvailable {
      guard let accelerometerTask = task as? BGProcessingTask else {
        return
      }
      // Start the accelerometer updates
      self.motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
        //            guard let accelerometerData = data else {
        //                return
        //            }
        
        // Do something with the accelerometer data, such as send it to a server
        if let acceleration = data?.acceleration {
          // Do something with the accelerometer data
          print("Acceleration x: \(acceleration.x), y: \(acceleration.y), z: \(acceleration.z)")
        }
        // Mark the task as complete
        accelerometerTask.setTaskCompleted(success: true)
      }
      print("what??")
      //      }
      
      //
      //      if motionManager.isGyroAvailable {
      //        guard let gyroscopeTask = task as? BGProcessingTask else {
      //            return
      //        }
      //        motionManager.startGyroUpdates(to: .main) { (data, error) in
      ////            guard let gyroscopeData = data else {
      ////                return
      ////            }
      //
      //            // Do something with the gyroscope data, such as send it to a server
      //          if let rotationRate = data?.rotationRate {
      //            // Do something with the gyroscope data
      //            print("Rotation rate x: \(rotationRate.x), y: \(rotationRate.y), z: \(rotationRate.z)")
      //          }
      //          // Mark the task as complete
      //          gyroscopeTask.setTaskCompleted(success: true)
      //        }
      //      }
      //    task.setTaskCompleted(success: true)
      self.scheduleBackgroundProcessing()
    }
    
  }

  @available(iOS 13.0, *)
  func scheduleBackgroundProcessing() {
    // Read sensor data for 100 seconds
//    DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
//       // Stop motion updates and complete the background task
//      self.motionManager.stopAccelerometerUpdates()
//      self.motionManager.stopGyroUpdates()
//      task.setTaskCompleted(success: true)
//    }
//
//    task.expirationHandler = {
//      self.motionManager.stopAccelerometerUpdates()
//      self.motionManager.stopGyroUpdates()
//      task.setTaskCompleted(success: false)
//    }
//
//    task.setTaskCompleted(success: true)
    let task = BGProcessingTaskRequest(identifier: backgroundTaskIdentifier)
    task.requiresNetworkConnectivity = true // Set to true if your task requires network connectivity
    task.requiresExternalPower = true  // Set to true if your task requires external power
    do {
      try BGTaskScheduler.shared.submit(task)
    } catch {
      print("Unable to submit task: \(error.localizedDescription)")
    }
  }
  
}
