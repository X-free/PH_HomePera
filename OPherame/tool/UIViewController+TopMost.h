//
//  UIViewController+TopMost.h
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TopMost)
/// 获取当前应用中最顶层的ViewController
+ (UIViewController *)topMostViewController;
@end

NS_ASSUME_NONNULL_END
