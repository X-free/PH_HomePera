//
//  AppDelegate.h
//  OPherame
//
//  Created by todesk on 2025/6/11.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// 与 SceneDelegate.window 同步；第三方（如 SHToast）会通过 delegate.window 取主窗口
@property (nonatomic, strong) UIWindow *window;

@end

