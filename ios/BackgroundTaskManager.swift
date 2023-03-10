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

let backgroundTaskIdentifier = "com.hangning.sensor.reading"


@objc(BackgroundTaskManager)
class BackgroundTaskManager : NSObject {
  let motionManager = CMMotionManager();
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
//  @objc func startReading(){
//
//    scheduleBackgroundTask();
//  }
  
//  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//      // Enable background fetch
//
//      // Register background task
//      BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
//          // Handle the task
//          self.handleBackgroundTask(task: task as! BGProcessingTask)
//      }
//      // Set up the background task request
//      let request = BGAppRefreshTaskRequest(identifier: "com.hangning.bgtask")
//      request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 15) // Start the task at least 15 minutes from now
//
//      return true
//  }
  
  @objc
  func start() {
    let task = BGProcessingTaskRequest(identifier: backgroundTaskIdentifier)
    task.requiresNetworkConnectivity = false // Set to true if your task requires network connectivity
    task.requiresExternalPower = false // Set to true if your task requires external power

    do {
      try BGTaskScheduler.shared.submit(task)
      scheduleMotionUpdates()
    } catch {
      print("Unable to submit task: \(error.localizedDescription)")
    }
  }
  
  @objc
  func cancel() {
    motionManager.stopAccelerometerUpdates()
    motionManager.stopGyroUpdates()
    BGTaskScheduler.shared.cancelAllTaskRequests()
  }
  
  private func scheduleMotionUpdates() {
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.1 // Set the desired update interval
      
      DispatchQueue.global(qos: .userInteractive).async {
         self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
           if let acceleration = data?.acceleration {
             // Do something with the accelerometer data
             print("Acceleration x: \(acceleration.x), y: \(acceleration.y), z: \(acceleration.z)")
           }
        }
      }
    }
    if motionManager.isGyroAvailable {
      motionManager.gyroUpdateInterval = 0.1 // Set the desired update interval
      DispatchQueue.global(qos: .userInteractive).async {
        self.motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
          if let rotationRate = data?.rotationRate {
            // Do something with the gyroscope data
            print("Rotation rate x: \(rotationRate.x), y: \(rotationRate.y), z: \(rotationRate.z)")
          }
        }
      }
    }
  }
  
  @objc
  func handleBackgroundTask(task: BGProcessingTask) {
    scheduleMotionUpdates()

    task.expirationHandler = {
      self.motionManager.stopAccelerometerUpdates()
      self.motionManager.stopGyroUpdates()
      task.setTaskCompleted(success: false)
    }

    task.setTaskCompleted(success: true)
  }
  
//  func scheduleBackgroundTask() {
//      let request = BGProcessingTaskRequest(identifier: backgroundTaskIdentifier)
//      request.requiresExternalPower = false
//      request.requiresNetworkConnectivity = false
//      request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
//
//      do {
//          try BGTaskScheduler.shared.submit(request)
//      } catch {
//          print("Error submitting background task: \(error.localizedDescription)")
//      }
//  }
  
}
