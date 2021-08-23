//
//  JProgressView.m
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import "JProgressView.h"

@interface JProgressView ()

/// 进度条背景
@property (nonatomic, strong) UIView *bgView;

/// 进度条
@property (nonatomic, strong) UIView *progressView;

/// 缓冲进度条
@property (nonatomic, strong) UIView *bufferProgressView;

/// 滑动按钮
@property (nonatomic, strong) UIButton *sliderBtn;

/// 记录滑动按钮上次中心点位置
@property (nonatomic, assign) CGPoint lastSliderCenter;

@end

@implementation JProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.bgView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(height/2, height/4, width - height, height/2);
        view.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        view;
    });
    [self addSubview:self.bgView];
    
    self.bufferProgressView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(height/2, height/4, 0, height/2);
        view.backgroundColor = [UIColor colorWithRed:113.0f/255.0f green:113.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
        view;
    });
    [self addSubview:self.bufferProgressView];
    
    self.progressView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(height/2, height/4, 0, height/2);
        view.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:159.0f/255.0f blue:209.0f/255.0f alpha:1.0f];
        view;
    });
    [self addSubview:self.progressView];
    
    self.sliderBtn = ({
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, 0, height, height);
        button.backgroundColor = UIColor.whiteColor;
        button.layer.cornerRadius = height/2;
        button.layer.masksToBounds = YES;
        button;
    });
    [self addSubview:self.sliderBtn];
    
    self.lastSliderCenter = self.sliderBtn.center;
    
    [self.sliderBtn addTarget:self action:@selector(onSlideBegin) forControlEvents:UIControlEventTouchDown];
    [self.sliderBtn addTarget:self action:@selector(onSlideEnd) forControlEvents:UIControlEventTouchCancel];
    [self.sliderBtn addTarget:self action:@selector(onSlideEnd) forControlEvents:UIControlEventTouchUpOutside];
    [self.sliderBtn addTarget:self action:@selector(onSlideEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.sliderBtn addTarget:self action:@selector(onSliderDraging:withEvent:) forControlEvents:UIControlEventTouchDragInside];
}

#pragma mark - Public

/// 设置进度
/// @param value 进度值
- (void)setProgress:(float)value {
    CGRect frame = self.progressView.frame;
    frame.size.width = (self.frame.size.width - self.frame.size.height) * value;
    self.progressView.frame = frame;
    
    CGPoint point = self.sliderBtn.center;
    point.x = CGRectGetMaxX(frame);
    self.sliderBtn.center = point;
}

/// 设置缓冲进度
/// @param value 缓冲进度值
- (void)setBufferProgress:(float)value {
    CGRect frame = self.bufferProgressView.frame;
    frame.size.width = (self.frame.size.width - self.frame.size.height) * value;
    self.bufferProgressView.frame = frame;
}

#pragma mark - 进度条滑动处理

/// 开始滑动
- (void)onSlideBegin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSlideBegin)]) {
        [self.delegate onSlideBegin];
    }
}

/// 停止滑动
- (void)onSlideEnd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSlideEnd)]) {
        [self.delegate onSlideEnd];
    }
}

/// 正在滑动
- (void)onSliderDraging:(UIButton *)sender withEvent:(UIEvent *)event {
    //  获取当前触屏位置相对于 self 原点的坐标
    CGPoint point = [[event.allTouches anyObject] locationInView:self.bgView];
    CGFloat x;
    if (point.x < 0) {
        x = 0;
    } else if (point.x > self.bgView.frame.size.width) {
        x = self.bgView.frame.size.width;
    } else {
        x = point.x;
    }
    
    float progressValue = x / self.bgView.frame.size.width;
    [self setProgress:progressValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSlideEnd)]) {
        [self.delegate onSlideDraging:progressValue];
    }
}

@end
