//
//  AppDelegate.m
//  美UI
//
//  Created by Lee on 15-12-17.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "MUITabBarViewController.h"
#import "MUIMeViewController.h"
#import "UMMobClick/MobClick.h"
#import <SVProgressHUD.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <WXApi.h>


static NSString *const kWeiXinAppId         = @"wx14093609e92b28c0";
static NSString *const kWeiXinAppSecret     = @"6c4aa8aa89cc6c5844f56f7b3029537d";
static NSString *const kUmengAppId          = @"577b1346e0f55a9a58003efb";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设定窗口的根控制器为TabBarController
    self.window.rootViewController = [[MUITabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // 启动完成显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 友盟统计SDK集成
    UMConfigInstance.appKey = kUmengAppId;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
            [ShareSDKConnector connectWeChat:[WXApi class]];
            break;
            default:
            break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
            [appInfo SSDKSetupWeChatByAppId:kWeiXinAppId
                                  appSecret:kWeiXinAppSecret];
            break;
            default:
            break;
        }
    }];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.6)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}
    
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
