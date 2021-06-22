//
//  JProgressView.h
//  MyVideoPlayer
//
//  Created by whaley on 2021/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JProgressView : UIView

/// 设置进度
/// @param value 进度值
- (void)setProgress:(float)value;

/// 设置缓冲进度
/// @param value 缓冲进度值
- (void)setBufferProgress:(float)value;

@end

NS_ASSUME_NONNULL_END
