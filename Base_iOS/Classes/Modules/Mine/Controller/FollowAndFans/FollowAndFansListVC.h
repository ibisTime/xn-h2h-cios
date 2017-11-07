//
//  FollowAndFansListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, FollowAndFansType) {
    
    FollowAndFansTypeFollow = 0,    //关注
    FollowAndFansTypeFans,          //粉丝
};

@interface FollowAndFansListVC : BaseViewController

@property (nonatomic, assign) FollowAndFansType type;

@end
