//
//  AppDelegate+TencentPush.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate+TencentPush.h"
#import <UserNotifications/UserNotifications.h>
#import "AppConfig.h"

@implementation AppDelegate (TencentPush)

#pragma mark - 远程推送
//注册推送
- (void)configTencentPushWithLaunchOption:(NSDictionary *)launchOptions {
    
    //打开通知栏触发
    [self notificationWithLaunchOptions:launchOptions];
    
    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:launchOptions];
}

- (void)notificationWithLaunchOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification != nil) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBarPushNotificaiton object:nil userInfo:remoteNotification];
        });
        
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self configOnAppRegistAPNSWithDeviceToken:deviceToken];
    
}

- (void)configOnAppRegistAPNSWithDeviceToken:(NSData *)deviceToken
{
    [[IMAPlatform sharedInstance] configOnAppRegistAPNSWithDeviceToken:deviceToken];

}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
//
//{
//    NSLog(@"%@", error);
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //    [TLAlert alertWithMsg:@""];
}
//  iOS 8 .9 后台进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self jpushDidReceiveRemoteApplication:application notification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#pragma mark - iOS 8 .9 后台进入前台

- (void)jpushDidReceiveRemoteApplication:(UIApplication *)application notification:(NSDictionary *)userInfo {
    
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    NSLog(@"%@", systemVersion);
    
//    JPushModel *model = [JPushModel mj_objectWithKeyValues:userInfo];
    
//    Aps *aps = model.aps;
//
//    UIViewController *topmostVC = [self topViewController];
//
//    if (application.applicationState > 0) {
//
//        [self checkMessageTypeWithModel:model vc:topmostVC];
//
//    }else if (application.applicationState == 0) {
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:aps.alert preferredStyle:UIAlertControllerStyleAlert];
//
//
//        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self checkMessageTypeWithModel:model vc:topmostVC];
//        }];
//
//        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
//
//        [alertController addAction:yesAction];
//
//        [alertController addAction:noAction];
//
//        [topmostVC presentViewController:alertController animated:YES completion:nil];
//
//    }
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        
    } else {
        
        // 判断为本地通知
        TLLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//点击消息会触发该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    
//    JPushModel *model = [JPushModel mj_objectWithKeyValues:userInfo];
    
    UIViewController *topmostVC = [self topViewController];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
//        [JPUSHService handleRemoteNotification:userInfo];
        
    } else {
        // 判断为本地通知
        //        TLLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

//- (void)checkMessageTypeWithModel:(JPushModel *)model vc:(UIViewController *)vc {
//
//    Aps *aps = model.aps;
//
//    NSInteger badge = aps.badge.integerValue;
//
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//
//    NSString *openType = model.openType;
//
//
//    if ([openType isEqualToString:@"0"]) {
//        //系统消息
//
//        SystemNoticeVC *systemNotice = [SystemNoticeVC new];
//
//        [vc.navigationController pushViewController:systemNotice animated:YES];
//
//
//    }else if ([openType isEqualToString:@"1"]) {
//
//        //进入帖子详情页
//        CSWArticleDetailVC *articleDetailVC = [CSWArticleDetailVC new];
//
//        articleDetailVC.articleCode = model.code;
//
//        [vc.navigationController pushViewController:articleDetailVC animated:YES];
//
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    [[IMAPlatform sharedInstance] configOnAppEnterBackground];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[IMAPlatform sharedInstance] configOnAppEnterForeground];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
 
//    [[TIMManager sharedInstance] doForeground];

}

- (void)configOnAppEnterBackground
{
    NSUInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:(int)unReadCount];
    
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        DebugLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        DebugLog(@"Fail: %d->%@", code, err);
    }];
}

@end
