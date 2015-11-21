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

static NSString *urlString = @"ws://192.168.7.59:8000";

@interface MotionClient() <MotionManagerDelegate, BOWebSocketWrapperDelegate>

@property (nonatomic, strong) MotionManager *motionManager;
@property (nonatomic, strong) BOWebsocketWrapper *websocket;

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
    }
    return self;
}

#pragma mark - MotionManagerDelegate

- (void)didChangeYaw:(CGFloat)newYaw
{
    NSString *message = [NSString stringWithFormat:@"yaw%.2f", newYaw];
    
    [self.websocket send:message];
}

- (void)didChangeRoll:(CGFloat)newRoll
{
    NSString *message = [NSString stringWithFormat:@"roll%.2f", newRoll];
    
    [self.websocket send:message];
}

#pragma mark - BOWebSocketWrapperDelegate

- (void)webSocket:(BOWebsocketWrapper *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Did receive message: %@", message);
}

@end
