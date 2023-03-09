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
let motionManager = CMMotionManager()

@objc(BackgroundTaskManager)
class BackgroundTaskManager : NSObject {
  
  @objc func startReading(){
    
    scheduleBackgroundTask();
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Enable background fetch
      
      // Register background task
      BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
          // Handle the task
          self.handleBackgroundTask(task: task as! BGProcessingTask)
      }
      // Set up the background task request
      let request = BGAppRefreshTaskRequest(identifier: "com.hangning.bgtask")
      request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 15) // Start the task at least 15 minutes from now
    
      return true
  }
  
  func startGyroscopeUpdates() {
    if motionManager.isGyroAvailable {
      motionManager.gyroUpdateInterval = 0.1
      motionManager.startGyroUpdates(to: .main) { (data, error) in
        guard let gyroData = data else { return }
        // Handle gyroscope data
      }
    }
  }
  
  func handleBackgroundTask(task: BGProcessingTask) {
      // Schedule the next background task
      scheduleBackgroundTask()
      
      // Perform the sensor reading logic here
//      task.expirationHandler = {
//        // Handle any cleanup required when the task expires
//
//      }
      
      // Call the task's completion handler when it's done
      task.setTaskCompleted(success: true)
  }
  
  func scheduleBackgroundTask() {
      let request = BGProcessingTaskRequest(identifier: backgroundTaskIdentifier)
      request.requiresExternalPower = false
      request.requiresNetworkConnectivity = false
      request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
      
      do {
          try BGTaskScheduler.shared.submit(request)
      } catch {
          print("Error submitting background task: \(error.localizedDescription)")
      }
  }
  
}
