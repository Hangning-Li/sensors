//
//  BackgroundTaskManager.m
//  sensors
//
//  Created by Hangning Li on 2023-03-03.
//

#import "BackgroundTaskManager.h"


@implementation BackgroundTaskManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(startReading) {
    [self scheduleBackgroundTask];
}

@end
