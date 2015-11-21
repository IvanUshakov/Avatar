//
//  MotionManager.m
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

@import Foundation;
@import QuartzCore;

static CGFloat minSignificantChange = 0.01;

#import "MotionManager.h"

@interface MotionManager()

@property (nonatomic, strong) CADisplayLink *motionDisplayLink;

@property (nonatomic, assign) CGFloat prevYaw;
@property (nonatomic, assign) CGFloat prevRoll;
@property (nonatomic, assign) CGFloat prevPitch;

@end

@implementation MotionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.prevYaw = 0;
        self.prevRoll = 0;
        self.prevPitch = 0;
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = .02;
        
        self.motionDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(motionRefresh:)];
        [self.motionDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        if ([self.motionManager isDeviceMotionAvailable]) {
            [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        }
    }
    return self;
}

- (void)motionRefresh:(id)sender
{
    double yaw = self.motionManager.deviceMotion.attitude.yaw;
    double roll = self.motionManager.deviceMotion.attitude.roll;
    double pitch = self.motionManager.deviceMotion.attitude.pitch;
    
    if ((fabs(self.prevYaw - yaw) > minSignificantChange) &&
        ([self.delegate respondsToSelector:@selector(didChangeYaw:)])) {
        [self.delegate didChangeYaw:yaw];

//        Degrees
//        CGFloat degrees = [self degreesWithRadians:yaw];
//        [self.delegate didChangeYaw:degrees];
    }
    
    if ((fabs(self.prevRoll - roll) > minSignificantChange) &&
        ([self.delegate respondsToSelector:@selector(didChangeRoll:)])) {
        [self.delegate didChangeRoll:roll];
    }
    
    if ((fabs(self.prevPitch - pitch) > minSignificantChange) &&
        ([self.delegate respondsToSelector:@selector(didChangePitch:)])) {
        [self.delegate didChangePitch:pitch];
    }
    
    self.prevYaw = yaw;
    self.prevRoll = roll;
    self.prevPitch = pitch;
}

- (CGFloat)degreesWithRadians:(CGFloat)radians
{
    return (180.0 / M_PI) * radians;
}

@end
