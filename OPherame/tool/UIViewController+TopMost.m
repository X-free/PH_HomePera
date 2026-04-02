//
//  UIViewController+TopMost.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "UIViewController+TopMost.h"

@implementation UIViewController (TopMost)
+ (UIViewController *)topMostViewController {
    // 从keyWindow开始查找
    UIWindow *keyWindow = [self _getKeyWindow];
    UIViewController *rootVC = keyWindow.rootViewController;
    
    return [self _findTopMostViewControllerFrom:rootVC];
}

#pragma mark - Private Methods

+ (UIWindow *)_getKeyWindow {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    // 如果没找到keyWindow，使用第一个window
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    
    return keyWindow;
}

+ (UIViewController *)_findTopMostViewControllerFrom:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        // 如果当前控制器present了其他控制器
        return [self _findTopMostViewControllerFrom:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        // 如果是TabBarController
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        if (tabBarController.selectedViewController) {
            return [self _findTopMostViewControllerFrom:tabBarController.selectedViewController];
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 如果是NavigationController
        UINavigationController *navigationController = (UINavigationController *)viewController;
        if (navigationController.visibleViewController) {
            return [self _findTopMostViewControllerFrom:navigationController.visibleViewController];
        }
    } else if ([viewController isKindOfClass:[UIPageViewController class]]) {
        // 如果是PageViewController
        UIPageViewController *pageViewController = (UIPageViewController *)viewController;
        if (pageViewController.viewControllers.count > 0) {
            return [self _findTopMostViewControllerFrom:pageViewController.viewControllers.firstObject];
        }
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        // 如果是SplitViewController
        UISplitViewController *splitViewController = (UISplitViewController *)viewController;
        if (splitViewController.viewControllers.count > 0) {
            return [self _findTopMostViewControllerFrom:splitViewController.viewControllers.lastObject];
        }
    }
    
    // 普通ViewController或者没有子控制器的情况
    return viewController;
}

@end
