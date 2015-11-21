//
//  MotionManager.h
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

@import CoreMotion;

@protocol MotionManagerDelegate <NSObject>

@optional

- (void)didChangeYaw:(CGFloat)newYaw;
- (void)didChangeRoll:(CGFloat)newRoll;
- (void)didChangePitch:(CGFloat)newPitch;

@end

@interface MotionManager : NSObject

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, weak) id <MotionManagerDelegate> delegate;

@end
