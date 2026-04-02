//
//  OPhNavigationController.h
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import <UIKit/UIKit.h>

@protocol OPhNavigationBackButtonDelegate <NSObject>
@optional


/// 返回按钮点击回调
- (void)navigationBackButtonDidClick;

/// 是否允许返回
/// @return YES允许返回，NO禁止返回
- (BOOL)shouldPopOnBackButtonClick;
@end


@interface OPhNavigationController : UINavigationController

@end


@interface UIViewController (CustomNavigation)

// 设置返回按钮图片
@property (nonatomic, strong) UIImage *customBackButtonImage;

// 设置返回按钮标题
@property (nonatomic, copy) NSString *customBackButtonTitle;

// 设置导航栏标题颜色
@property (nonatomic, strong) UIColor *customTitleColor;

// 设置导航栏标题字体
@property (nonatomic, strong) UIFont *customTitleFont;

// 返回到指定控制器
- (void)popToSpecificViewController:(Class)targetClass;



@end
