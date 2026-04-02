//
//  WKWebViewController.h
//  OPherame
//
//  Created by todesk on 2025/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewController : UIViewController
/// 初始化方法
/// @param urlString 要加载的网页URL字符串
- (instancetype)initWithURLString:(NSString *)urlString;

/// 主题色（默认系统蓝色）
@property (nonatomic, strong) UIColor *themeColor;


@property (nonatomic, strong)NSString *harukos;


@end

NS_ASSUME_NONNULL_END
