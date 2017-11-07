//
//  CouponListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"

typedef NS_ENUM(NSInteger, CouponStatusType) {

    CouponStatusTypeUse = 0,        //可用
    CouponStatusTypeUnUse,          //不可用
    CouponStatusTypeOverdue,         //已过期
};

typedef void(^CouponSelectBlock)(CouponModel *coupon);

@interface CouponListVC : BaseViewController

@property (nonatomic, copy) CouponSelectBlock couponBlock;

@property (nonatomic, assign) CouponStatusType statusType;

@end
