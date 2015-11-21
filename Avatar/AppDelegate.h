//
//  AppDelegate.h
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

@import UIKit;

#import "MotionManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MotionManager *motionManager;

@end

