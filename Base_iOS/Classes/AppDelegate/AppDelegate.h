//
//  AppDelegate.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ImSDK/TIMManager.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : IMAAppDelegate <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CLLocationManager *locationManage;

@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate;

- (void)pushToChatViewControllerWith:(IMAUser *)user;

@end
