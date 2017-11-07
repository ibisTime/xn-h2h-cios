//
//  CouponCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface CouponCell : UITableViewCell

@property (nonatomic, strong) CouponModel *coupon;

@property (nonatomic,strong) UIButton *selectedBtn;

@property(nonatomic, strong) UILabel *textLbl;

@end
