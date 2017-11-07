//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "WXApi.h"

#import "AppDelegate+Launch.h"
#import "AppDelegate+BaiduMap.h"
#import "AppDelegate+TencentPush.h"

#import "NavigationController.h"
#import "TabbarViewController.h"
//#import "HomeVC.h"
#import "TLUserLoginVC.h"
#import "PublishVC.h"
//#import "IMAPlatform.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    
    TabbarViewController *tab = (TabbarViewController *)self.window.rootViewController;
    
    [tab pushToChatViewControllerWith:user];
}

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    
    //初始化IMAPlatform
    [self initIMAPlatform];
    
    //键盘
    [self configIQKeyboard];
    
    //配置地图
    [self configMapKit];
    
    //配置腾讯云推送
    [self configTencentPushWithLaunchOption:launchOptions];
    
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self configOnAppRegistAPNSWithDeviceToken:deviceToken];
    
}

- (void)configOnAppRegistAPNSWithDeviceToken:(NSData *)deviceToken
{
    [[IMAPlatform sharedInstance] configOnAppRegistAPNSWithDeviceToken:deviceToken];
    
}

// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;
        
    } else {
        
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
        
    }
    
    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;
        
    } else {
        
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
        
    }
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
}

- (void)initIMAPlatform {
    
    [IMAPlatform configWith:nil];
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[PublishVC class]];
    

}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self launchEventWithCompletionHandle:^(LaunchOption launchOption) {
        
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        self.window.rootViewController = tabbarCtrl;
        
        //重新登录
        if([TLUser user].isLogin) {
            
            //初始化用户信息
            [[TLUser user] initUserData];
            
            [[TLUser user] reLogin];
            
        };
        
    }];
}

#pragma mark 微信支付结果
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果
        NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:[NSNumber numberWithInt:resp.errCode]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
