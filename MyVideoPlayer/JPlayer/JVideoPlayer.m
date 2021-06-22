//
//  JVideoPlayer.m
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import "JVideoPlayer.h"

@interface JVideoPlayer ()

@property (nonatomic, strong) NSURL *jVideoURL;
@property (nonatomic, strong) AVPlayerItem *jPlayerItem;
@property (nonatomic, strong) AVPlayer *jPlayer;

@property (nonatomic, strong) UIView *attendView;

@end

@implementation JVideoPlayer

- (instancetype)player {
    static dispatch_once_t onceToken;
    static JVideoPlayer *player;
    dispatch_once(&onceToken, ^{
        player = [[JVideoPlayer alloc] init];
    });
    return player;
}

#pragma mark - public

- (void)setURLWithString:(NSString *)urlString andAttendView:(UIView *)attendView {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([url isEqual:_jVideoURL]) {
        return;
    }
    
    _jVideoURL = url;
    _attendView = attendView;
    _jPlayerItem = [AVPlayerItem playerItemWithURL:url];
    _jPlayer = [AVPlayer playerWithPlayerItem:_jPlayerItem];
}

/// 播放视频
- (void)play {
    [_jPlayer play];
}

/// 暂停视频
- (void)pause {
    [_jPlayer pause];
}

@end
