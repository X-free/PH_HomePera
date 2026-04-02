//
//  UIView+FrameUtil.m
//  OPherame
//
//  Created by todesk on 2025/6/23.
//

#import "UIView+FrameUtil.h"

@implementation UIView (Frame)

#pragma mark - 基础属性
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - 尺寸和位置
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark - 中心点
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark - 边界
- (CGFloat)top {
    return self.y;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

- (CGFloat)left {
    return self.x;
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    self.x = right - self.width;
}

#pragma mark - 便捷方法
- (void)addX:(CGFloat)delta {
    self.x += delta;
}

- (void)addY:(CGFloat)delta {
    self.y += delta;
}

- (void)addWidth:(CGFloat)delta {
    self.width += delta;
}

- (void)addHeight:(CGFloat)delta {
    self.height += delta;
}

#pragma mark - 新增：导航栏和分栏高度相关
+ (CGFloat)navigationBarHeight {
    return 44.0f; // 标准导航栏高度
}

+ (CGFloat)tabBarHeight {
    return 49.0f; // 标准TabBar高度
}

+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

#pragma mark - 安全区域相关便捷方法
- (CGFloat)safeAreaTop {
    return [UIView safeAreaInsets].top;
}

- (CGFloat)safeAreaBottom {
    return [UIView safeAreaInsets].bottom;
}

- (CGFloat)safeAreaLeft {
    return [UIView safeAreaInsets].left;
}

- (CGFloat)safeAreaRight {
    return [UIView safeAreaInsets].right;
}


+ (UIColor *)colorFromRGB:(NSInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}


- (void)addDashedBorderWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth dashPattern:(NSArray<NSNumber *> *)dashPattern {
    // 移除已有的虚线边框
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"dashedBorder"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.lineDashPattern = dashPattern;
    borderLayer.lineWidth = lineWidth;
    borderLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    borderLayer.frame = self.bounds;
    borderLayer.name = @"dashedBorder";
    
    [self.layer addSublayer:borderLayer];
}
@end
