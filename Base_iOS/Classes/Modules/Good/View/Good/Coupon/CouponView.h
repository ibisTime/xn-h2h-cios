//
//  CouponView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

typedef void(^CouponDone)(NSInteger index);

@interface CouponView : UIView

@property (nonatomic, copy) CouponDone done;

@property (nonatomic, strong) NSArray <CouponModel *>*coupons;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
