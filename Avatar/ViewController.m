//
//  ViewController.m
//  Avatar
//
//  Created by Alex Edunov on 21/11/15.
//  Copyright © 2015 AlexEdunov. All rights reserved.
//

#import "ViewController.h"
#import <PBJVideoPlayer/PBJVideoPlayer.h>
#import "Masonry.h"

static NSString * const StreamUrl = @"https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8";

@interface ViewController () <PBJVideoPlayerControllerDelegate> {
    PBJVideoPlayerController *_videoPlayerController;
    UIImageView *_playButton;
}

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _videoPlayerController = [[PBJVideoPlayerController alloc] init];
    _videoPlayerController.delegate = self;
    [self addChildViewController:_videoPlayerController];
    [self.view addSubview:_videoPlayerController.view];
    [_videoPlayerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    [_videoPlayerController didMoveToParentViewController:self];
    
    _playButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
    _playButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [self.view bringSubviewToFront:_playButton];
    NSURL *bipbopUrl = [[NSURL alloc] initWithString:StreamUrl];
    _videoPlayerController.asset = [[AVURLAsset alloc] initWithURL:bipbopUrl options:nil];
}

#pragma mark - PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    if (videoPlayer.playbackState == PBJVideoPlayerPlaybackStatePaused) {
        _playButton.hidden = NO;
    } else if (videoPlayer.playbackState == PBJVideoPlayerPlaybackStatePlaying) {
        _playButton.hidden = YES;
    }
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    switch (videoPlayer.bufferingState) {
     case PBJVideoPlayerBufferingStateUnknown:
     NSLog(@"Buffering state unknown!");
     break;
     
     case PBJVideoPlayerBufferingStateReady:
     NSLog(@"Buffering state Ready! Video will start/ready playing now.");
     break;
     
     case PBJVideoPlayerBufferingStateDelayed:
     NSLog(@"Buffering state Delayed! Video will pause/stop playing now.");
     break;
     default:
     break;
     }
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{

}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{

}

@end
