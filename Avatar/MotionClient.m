//
//  MotionClient.m
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

#import "MotionClient.h"
#import "MotionManager.h"
#import "BOWebsocketWrapper.h"

typedef NS_ENUM(NSInteger, Direction) {
    DirectionNegative = -1,
    DirectionPositive = 1
};

static NSString *urlString = @"ws://192.168.7.59:8000";

static CGFloat degreesByStepYaw = 15;
static CGFloat degreesByStepRoll = 7.5;

@interface MotionClient() <MotionManagerDelegate, BOWebSocketWrapperDelegate>

@property (nonatomic, strong) MotionManager *motionManager;
@property (nonatomic, strong) BOWebsocketWrapper *websocket;

@property (nonatomic, assign) CGFloat yawRest;
@property (nonatomic, assign) CGFloat rollRest;

@end

@implementation MotionClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *URL = [NSURL URLWithString:urlString];
        self.websocket = [[BOWebsocketWrapper alloc] initWithURL:URL];
        self.websocket.delegate = self;
        
        self.motionManager = [MotionManager new];
        self.motionManager.delegate = self;
        
        self.yawRest = 0;
        self.rollRest = 0;
    }
    return self;
}

#pragma mark - MotionManagerDelegate

- (void)didChangeYaw:(CGFloat)yawDelta
{
    CGFloat degrees = yawDelta * (180 / M_PI) + self.yawRest;
    NSUInteger steps = round(fabs(degrees) / degreesByStepYaw);

    Direction direction = (yawDelta > 0) ? DirectionPositive : DirectionNegative;
    
    self.yawRest = degrees - steps * degreesByStepYaw * direction;

    char symbol = (direction == DirectionPositive) ? 0x1 : 0x2;
    NSData *message = [NSData dataWithBytes:&symbol length:1];
    
    for (int i = 0; i < steps; i++) {
        [self.websocket send:message];
    }
}

- (void)didChangeRoll:(CGFloat)rollDelta
{
    CGFloat degrees = rollDelta * (180 / M_PI) + self.rollRest;
    NSUInteger steps = round(fabs(degrees) / degreesByStepRoll);
    
    Direction direction = (rollDelta > 0) ? DirectionPositive : DirectionNegative;
    
    self.rollRest = degrees - steps * degreesByStepRoll * direction;
    
    char symbol = (direction == DirectionPositive) ? 0x3 : 0x4;
    NSData *message = [NSData dataWithBytes:&symbol length:1];
    
    for (int i = 0; i < steps; i++) {
        [self.websocket send:message];
    }
}

#pragma mark - BOWebSocketWrapperDelegate

- (void)webSocket:(BOWebsocketWrapper *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Did receive message: %@", message);
}

@end
