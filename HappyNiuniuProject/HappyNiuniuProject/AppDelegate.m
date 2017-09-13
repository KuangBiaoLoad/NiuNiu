//
//  AppDelegate.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "AppDelegate.h"
#import "MZLoginController.h"
#import "MZNavgationController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MZlocalizableContoller.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 语言初始化
    [MZlocalizableContoller initUserLanguage];
    // 监控语言切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange:) name:RDNotificationLanguageChanged object:nil];
    
    MZLoginController *loginVC =[[MZLoginController alloc] initWithNibName:@"MZLoginController" bundle:nil];
    MZNavgationController *loginNav = [[MZNavgationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = loginNav;
    [self.window makeKeyAndVisible];
    
    /** 开启键盘监听*/
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];//隐藏工具条
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;//点击背景收回键盘
    
    [Common saveUUIDToKeyChain];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDNotificationLanguageChanged object:nil];
}

- (void)languageChange:(NSNotification *)note{
    // 在该方法里实现重新初始化 rootViewController 的行为，并且所有带有文字的页面都要重新渲染
    // 比如：[UIApplication sharedApplication].keyWindow.rootViewController = ...;
}


@end
