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

@end
