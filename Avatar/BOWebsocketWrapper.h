//
//  BOWebSocketWrapper.h
//  Binomo
//
//  Created by Alex Edunov on 20/08/15.
//  Copyright (c) 2015 Binomo. All rights reserved.
//

@import Foundation;

@class BOWebsocketWrapper;

@protocol BOWebSocketWrapperDelegate <NSObject>

- (void)webSocket:(BOWebsocketWrapper *)webSocket didReceiveMessage:(id)message;

@end

@interface BOWebsocketWrapper : NSObject

@property (nonatomic, weak) id <BOWebSocketWrapperDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;
- (void)send:(id)message;

@end
