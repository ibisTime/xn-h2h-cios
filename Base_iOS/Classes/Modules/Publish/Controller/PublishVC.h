//
//  PublishVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PublishSuccess)();

@interface PublishVC : BaseViewController
//活动
@property (nonatomic, copy) NSString *activityCode;

@property (nonatomic, copy) PublishSuccess publishSuccess;
//包邮
@property (nonatomic, copy) NSString *freightType;

@end
