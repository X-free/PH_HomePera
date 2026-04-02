//
//  UIView+FrameUtil.h
//  OPherame
//
//  Created by todesk on 2025/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FrameUtil)

// 基础属性
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// 尺寸和位置
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

// 中心点
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

// 边界
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

// 便捷方法
- (void)addX:(CGFloat)delta;
- (void)addY:(CGFloat)delta;
- (void)addWidth:(CGFloat)delta;
- (void)addHeight:(CGFloat)delta;

// 新增：导航栏和分栏高度相关
+ (CGFloat)navigationBarHeight;
+ (CGFloat)tabBarHeight;
+ (CGFloat)statusBarHeight;
+ (UIEdgeInsets)safeAreaInsets;

// 新增：安全区域相关便捷方法
- (CGFloat)safeAreaTop;
- (CGFloat)safeAreaBottom;
- (CGFloat)safeAreaLeft;
- (CGFloat)safeAreaRight;


// 从十六进制RGB值创建颜色 (格式: 0xRRGGBB)
+ (UIColor *)colorFromRGB:(NSInteger)rgbValue;

// 从十六进制字符串创建颜色 (格式: @"#RRGGBB" 或 @"RRGGBB")
+ (UIColor *)colorFromHexString:(NSString *)hexString;

- (void)addDashedBorderWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth dashPattern:(NSArray<NSNumber *> *)dashPattern;
@end

NS_ASSUME_NONNULL_END
