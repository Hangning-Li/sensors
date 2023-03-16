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
    scheduleBackgroundProcessing()
    print("hello")
  }
  
  
  // Register the task
  func registerBackgroundTask() {

  }
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Enable background fetch
    
      // Register background task
    
      BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
        // Handle the task
        self.handleBackgroundTask(task: task as! BGProcessingTask)
        if #available(iOS 14.0, *) {
          Logger().info("[BGTASK] Perform bg processing \(self.backgroundTaskIdentifier)")
        }
        
//        task.setTaskCompleted(success: true)
      }
      self.scheduleBackgroundProcessing()
    
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
  func handleBackgroundTask(task: BGProcessingTask) {
      // Handle the task
      // Create a motion manager
      // Set up the accelerometer
      motionManager.accelerometerUpdateInterval = 0.1 // Update interval in seconds
      motionManager.gyroUpdateInterval = 0.1
      
//      if motionManager.isAccelerometerAvailable {
        guard let accelerometerTask = task as? BGProcessingTask else {
            return
        }
        // Start the accelerometer updates
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
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
    
  }

  @available(iOS 13.0, *)
  func scheduleBackgroundProcessing() {
     
    let taskRequest = BGProcessingTaskRequest(identifier: self.backgroundTaskIdentifier)
    taskRequest.requiresNetworkConnectivity = false
    taskRequest.requiresExternalPower = false
    taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 2)
    
    // Read sensor data for 100 seconds
//    DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
//       // Stop motion updates and complete the background task
//      self.motionManager.stopAccelerometerUpdates()
//      self.motionManager.stopGyroUpdates()
//      taskRequest.setTaskCompleted(success: true)
//    }
    
    do {
        try BGTaskScheduler.shared.submit(taskRequest)
    } catch {
        print("Error submitting background task: \(error.localizedDescription)")
    }
  }

  
}
