//
//  SceneDelegate.m
//  OPherame
//
//  Created by todesk on 2025/6/11.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "VeiLogController.h"
#import "HoPerController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    // 在初始化时添加这些配置
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 20.0f; // 键盘与输入框的距离
    [IQKeyboardManager sharedManager].layoutIfNeededOnUpdate = YES; // 自动重新布局
    
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
//        if (token) {
//            OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[HoPerController alloc] init]];
//            self.window.rootViewController = navOdController;
//            [self.window makeKeyAndVisible];
//        }else{
//            // 创建并展示VeiLogController
//            OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
//            self.window.rootViewController = navOdController;
//            [self.window makeKeyAndVisible];
//        }
        
        
        OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[HoPerController alloc] init]];
        self.window.rootViewController = navOdController;
        [self.window makeKeyAndVisible];
        
        if ([UIApplication sharedApplication].delegate) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window = self.window;
        }
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}




@end
