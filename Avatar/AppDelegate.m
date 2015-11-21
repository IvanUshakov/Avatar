//
//  AppDelegate.m
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <MotionManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.motionManager = [MotionManager new];
    self.motionManager.delegate = self;
    
    return YES;
}

#pragma mark - MotionManagerDelegate

- (void)didChangeYaw:(CGFloat)newYaw
{
    NSLog(@"Yaw: %.2f", newYaw);
}

- (void)didChangeRoll:(CGFloat)newRoll
{
    NSLog(@"Roll: %.2f", newRoll);
}

@end
