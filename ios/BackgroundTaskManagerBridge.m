//
//  BackgroundTaskManagerBridge.m
//  sensors
//
//  Created by Hangning Li on 2023-03-03.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

//@interface RCT_EXTERN_MODULE(BackgroundTaskManager, NSObject)
//
//RCT_EXTERN_METHOD(startReading);
//+ (BOOL)requiresMainQueueSetup {
//  return YES;
//}
//@end

@interface MyAppBridge : NSObject <RCTBridgeModule, RCTEventEmitter>

@end
