//
//  BackgroundTaskManager.swift
//  sensors
//
//  Created by Hangning Li on 2023-03-03.
//

import Foundation
import UIKit
import BackgroundTasks

let backgroundTaskIdentifier = "com.hangning.sensor.reading"

@objc(BackgroundTaskManager)
class BackgroundTaskManager : NSObject {
  
  @objc func startReading(_ options: NSDictionary) -> Void {
    scheduleBackgroundTask();
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Register background task
      BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
          // Handle the task
          self.handleBackgroundTask(task: task as! BGProcessingTask)
      }
      return true
  }
  
  func handleBackgroundTask(task: BGProcessingTask) {
      // Schedule the next background task
      scheduleBackgroundTask()
      
      // Perform your sensor reading logic here
      
      // Call the task's completion handler when you're done
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
