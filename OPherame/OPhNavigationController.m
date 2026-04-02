//
//  OPhNavigationController.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "OPhNavigationController.h"
#import <objc/runtime.h>

// 默认配置
#define DEFAULT_BACK_BUTTON_IMAGE [UIImage imageNamed:@"rtunm"]
#define DEFAULT_TITLE_COLOR [UIColor whiteColor]
#define DEFAULT_TITLE_FONT [UIFont systemFontOfSize:18]

@implementation UIViewController (CustomNavigation)

static char kCustomBackButtonImageKey;
static char kCustomBackButtonTitleKey;
static char kCustomTitleColorKey;
static char kCustomTitleFontKey;

- (void)setCustomBackButtonImage:(UIImage *)customBackButtonImage {
    objc_setAssociatedObject(self, &kCustomBackButtonImageKey, customBackButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNavigationItems];
}

- (UIImage *)customBackButtonImage {
    UIImage *image = objc_getAssociatedObject(self, &kCustomBackButtonImageKey);
    return image ?: DEFAULT_BACK_BUTTON_IMAGE; // 返回自定义图片或默认图片
}

- (void)setCustomBackButtonTitle:(NSString *)customBackButtonTitle {
    objc_setAssociatedObject(self, &kCustomBackButtonTitleKey, customBackButtonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self updateNavigationItems];
}

- (NSString *)customBackButtonTitle {
    return objc_getAssociatedObject(self, &kCustomBackButtonTitleKey);
}

- (void)setCustomTitleColor:(UIColor *)customTitleColor {
    objc_setAssociatedObject(self, &kCustomTitleColorKey, customTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateTitleAttributes];
}

- (UIColor *)customTitleColor {
    UIColor *color = objc_getAssociatedObject(self, &kCustomTitleColorKey);
    return color ?: DEFAULT_TITLE_COLOR; // 返回自定义颜色或默认颜色
}

- (void)setCustomTitleFont:(UIFont *)customTitleFont {
    objc_setAssociatedObject(self, &kCustomTitleFontKey, customTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateTitleAttributes];
}

- (UIFont *)customTitleFont {
    UIFont *font = objc_getAssociatedObject(self, &kCustomTitleFontKey);
    return font ?: DEFAULT_TITLE_FONT; // 返回自定义字体或默认字体
}

- (void)updateNavigationItems {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        
        if (self.customBackButtonImage) {
            backItem.image =
            [self.customBackButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        if (self.customBackButtonTitle) {
            backItem.title = self.customBackButtonTitle;
        } else {
            backItem.title = @"";
        }
        
        self.navigationItem.backBarButtonItem = backItem;
    }
}

- (void)updateTitleAttributes {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (self.customTitleColor) {
        attributes[NSForegroundColorAttributeName] = self.customTitleColor;
    }
    
    if (self.customTitleFont) {
        attributes[NSFontAttributeName] = self.customTitleFont;
    }
    
    if (attributes.count > 0) {
        self.navigationController.navigationBar.titleTextAttributes = attributes;
    }
}

// 返回到指定控制器
- (void)popToSpecificViewController:(Class)targetClass {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:targetClass]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    // 如果没有找到，默认返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}

@end


@implementation OPhNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置默认样式
       self.navigationBar.tintColor = [UIColor whiteColor];
       
       // 应用默认标题样式
       NSDictionary *titleAttributes = @{
           NSForegroundColorAttributeName: DEFAULT_TITLE_COLOR,
           NSFontAttributeName: DEFAULT_TITLE_FONT
       };
       self.navigationBar.titleTextAttributes = titleAttributes;
       
       self.interactivePopGestureRecognizer.delegate = nil;
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 在push前配置返回按钮
    [viewController updateNavigationItems];
    [viewController updateTitleAttributes];
//
    [super pushViewController:viewController animated:animated];
    
    // 修复iOS14侧滑返回失效问题
    if (@available(iOS 14.0, *)) {
        viewController.navigationItem.backButtonDisplayMode = UINavigationItemBackButtonDisplayModeMinimal;
    }
}




- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 获取当前顶部的视图控制器
    UIViewController *topVC = self.topViewController;
    
    // 检查是否实现了协议方法
    if ([topVC conformsToProtocol:@protocol(OPhNavigationBackButtonDelegate)]) {
        id<OPhNavigationBackButtonDelegate> delegate = (id<OPhNavigationBackButtonDelegate>)topVC;
        
        // 检查是否实现了特定方法
        if ([delegate respondsToSelector:@selector(shouldPopOnBackButtonClick)]) {
            // 调用方法判断是否允许返回
            BOOL shouldPop = [delegate shouldPopOnBackButtonClick];
            if (!shouldPop) {
                return nil; // 不允许返回
            }
        }
        
        // 调用返回按钮点击回调
        if ([delegate respondsToSelector:@selector(navigationBackButtonDidClick)]) {
            [delegate navigationBackButtonDidClick];
            return nil;
        }
    }
    
    // 允许返回的情况
    return [super popViewControllerAnimated:animated];
}



@end
