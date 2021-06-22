//
//  JVideoView.m
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import "JVideoView.h"
#import "JProgressView.h"

@interface JVideoView ()

@property (nonatomic, strong) AVPlayerItem *jPlayerItem;
@property (nonatomic, strong) AVPlayer *jPlayer;
@property (nonatomic, strong) AVPlayerLayer *jPlayerLayer;

/// 控制层UI
@property (nonatomic, strong) UIView *controllerView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) JProgressView *progressView;

@end

@implementation JVideoView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotification];
        [self createUI];
    }
    return self;
}

#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView)];
    [self addGestureRecognizer:tapGR];
    
    UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTapView)];
    doubleTapGR.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGR];
    [tapGR requireGestureRecognizerToFail:doubleTapGR];
    
    [self createVideoLayer];
    [self createControllerLayer];
}

/// 视频图层
- (void)createVideoLayer {
    NSURL *url = [NSURL URLWithString:@"http://live.numgg.com/upload/user/20201230/7009933d1253f1e06e52e0b0c641e593.mp4"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    //监听播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听缓存进度
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.jPlayerItem = playerItem;
    
    self.jPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.jPlayer.volume = 0;
    
    //监听播放进度
    __weak typeof(self) weakSelf = self;
    [self.jPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (weakSelf == nil) return;
        
        Float64 currentPlayTime = CMTimeGetSeconds(weakSelf.jPlayer.currentTime);
        Float64 totalTime = CMTimeGetSeconds(weakSelf.jPlayerItem.duration);
        Float64 progress = currentPlayTime/totalTime;
        [weakSelf.progressView setProgress:progress];
    }];
    
    self.jPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.jPlayer];
    self.jPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.jPlayerLayer.frame = self.bounds;
    [self.layer addSublayer:self.jPlayerLayer];
}

/// 控制图层
- (void)createControllerLayer {
    UIView *controllerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:controllerView];
    self.controllerView = controllerView;
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.frame = CGRectMake(controllerView.frame.size.width - 50 - 10, controllerView.frame.size.height - 50 - 50, 50, 50);
    [playImageView setImage:[UIImage imageNamed:@"playIcon"]];
    [controllerView addSubview:playImageView];
    self.playImageView = playImageView;
    
    UIButton *playBtn = [[UIButton alloc] init];
    playBtn.frame = CGRectMake(10, controllerView.frame.size.height - 30 - 10, 30, 30);
    [playBtn setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(onTapPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.selected = NO;
    [controllerView addSubview:playBtn];
    self.playBtn = playBtn;
    
    UIButton *fullBtn = [[UIButton alloc] init];
    fullBtn.frame = CGRectMake(controllerView.frame.size.width - 30 - 10, 0, 30, 30);
    CGPoint point = fullBtn.center;
    point.y = playBtn.center.y;
    fullBtn.center = point;
    [fullBtn setImage:[UIImage imageNamed:@"fullBtn"] forState:UIControlStateNormal];
    [fullBtn addTarget:self action:@selector(onTapFullBtn:) forControlEvents:UIControlEventTouchUpInside];
    [controllerView addSubview:fullBtn];
    
    CGFloat x = CGRectGetMaxX(playBtn.frame) + 10;
    JProgressView *progressView = [[JProgressView alloc] initWithFrame:CGRectMake(x, 0, CGRectGetMinX(fullBtn.frame) - CGRectGetMaxX(playBtn.frame) - 20, 10)];
    point = progressView.center;
    point.y = playBtn.center.y;
    progressView.center = point;
    [controllerView addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                [self.jPlayer play];
                self.playImageView.hidden = YES;
                self.playBtn.selected = YES;
                break;
            }
                
            case AVPlayerItemStatusFailed:
                break;
                
            case AVPlayerItemStatusUnknown:
                break;

            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        //获取视频缓冲进度数组，这些数组可能是不连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
        //缓冲区间的开始时间
        Float64 loadedStartTime = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        Float64 loadedDurationTime = CMTimeGetSeconds(timeRange.duration);
        //当前视频总缓冲时长
        Float64 totalLoadedTime = loadedStartTime + loadedDurationTime;
        //当前视频总时长
        Float64 totalTime = CMTimeGetSeconds(playerItem.duration);
        [self.progressView setBufferProgress:(totalLoadedTime/totalTime)];
    }
}

#pragma mark - Event

- (void)onTapView {
    BOOL flag = self.controllerView.isHidden;
    self.controllerView.hidden = !flag;
}

- (void)onDoubleTapView {
    [self changePlayStatus];
}

- (void)onTapPlayBtn:(UIButton *)sender {
    NSLog(@"Tap play button.");
    [self changePlayStatus];
}

- (void)onTapFullBtn:(UIButton *)sender {
    NSLog(@"Enter full modal.");
}

#pragma mark - Notification

- (void)addNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onPlayerItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)onPlayerItemDidPlayToEndTime {
    __weak typeof(self) weakSelf = self;
    [self.jPlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        [weakSelf.jPlayer play];
    }];
}

#pragma mark - Private

- (void)changePlayStatus {
    BOOL flag = self.playBtn.isSelected;
    if (flag) {
        [self.jPlayer pause];
        self.playImageView.hidden = NO;
    } else {
        [self.jPlayer play];
        self.playImageView.hidden = YES;
    }
    self.playBtn.selected = !flag;
}

#pragma mark - dealloc

- (void)dealloc
{
    [self removeNotification];
    [self.jPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.jPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

@end
