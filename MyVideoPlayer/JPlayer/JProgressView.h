//
//  JProgressView.h
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JProgressViewDelegate <NSObject>

@optional

/// 进度按钮开始滑动
- (void)onSlideBegin;

/// 进度按钮结束滑动
- (void)onSlideEnd;

/// 进度按钮滑动
/// @param value 当前滑动位置对应进度百分比
- (void)onSlideDraging:(float)value;

@end

@interface JProgressView : UIView

@property (nonatomic, weak) id<JProgressViewDelegate> delegate;

/// 设置进度
/// @param value 进度值
- (void)setProgress:(float)value;

/// 设置缓冲进度
/// @param value 缓冲进度值
- (void)setBufferProgress:(float)value;

@end

NS_ASSUME_NONNULL_END
