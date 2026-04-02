//
//  VerticalMarqueeView.h
//  OPherame
//
//  Created by todesk on 2025/6/28.
//

#import <UIKit/UIKit.h>
#import "LoanResponseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VerticalMarqueeView : UIView
/**
 * 数据源数组（NSString数组）
 */
@property (nonatomic, strong) NSArray<DrewParItem *> *messages;

/**
 * 滚动速度（默认0.8秒/条）
 */
@property (nonatomic, assign) NSTimeInterval scrollInterval;

/**
 * 动画持续时间（默认0.5秒）
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 * 文本字体（默认系统字体16号）
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 * 文本颜色（默认黑色）
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * 初始化方法
 * @param frame 控件frame
 * @param messages 消息数组
 */
- (instancetype)initWithFrame:(CGRect)frame messages:(NSArray<DrewParItem *> *)messages;

/**
 * 开始滚动
 */
- (void)startScrolling;

/**
 * 停止滚动
 */
- (void)stopScrolling;

/**
 * 设置点击回调
 * @param handler 点击回调（返回点击的index和内容）
 */
- (void)setClickHandler:(void (^)(NSInteger index, NSString *message))handler;
@end

NS_ASSUME_NONNULL_END
