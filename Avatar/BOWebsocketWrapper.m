//
//  BOWebSocketWrapper.m
//  Binomo
//
//  Created by Alex Edunov on 20/08/15.
//  Copyright (c) 2015 Binomo. All rights reserved.
//

#import "BOWebsocketWrapper.h"

@import SocketRocket;

#import "NSMutableArray+QueueAdditions.h"

@interface BOWebsocketWrapper() <SRWebSocketDelegate>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation BOWebsocketWrapper

- (instancetype)init
{
    return [self initWithURL:[[NSURL alloc] init]];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.URL = URL;
    }
    return self;
}

- (void)send:(id)message
{
    [self openIfNeeded];
    
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:message];
    } else {
        [self.queue enqueue:message];
    }
}

- (void)dealloc
{
    [self closeAndRelease];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    if (![self.queue empty]) {
        id message = [self.queue dequeue];
        [self.webSocket send:message];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket Failed With Error %@", error);
    [self reopen];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    [self.delegate webSocket:self didReceiveMessage:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
}

#pragma mark - Private

- (void)open
{
    [self.webSocket open];
}

- (void)openIfNeeded
{
    if (self.webSocket.readyState == SR_CONNECTING) {
        [self open];
    }
}

- (void)closeAndRelease
{
    [self.webSocket close];
    self.webSocket.delegate = nil;
    self.webSocket = nil;
}

- (void)reopen;
{
    [self closeAndRelease];
    [self openIfNeeded];
}

#pragma mark - Lazy loading

- (SRWebSocket *)webSocket
{
    if (!_webSocket) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
        
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        _webSocket.delegate = self;
    }
    
    return _webSocket;
}

- (NSMutableArray *)queue
{
    if (!_queue) {
        _queue = [NSMutableArray array];
    }
    
    return _queue;
}

@end
