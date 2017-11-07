//
//  RechargeTableView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseTableView.h"
typedef NS_ENUM(NSInteger, PayType) {

    PayTypeWxPay = 0,
    PayTypeAlipay,
};

typedef void (^RechargeCellBlock) (NSIndexPath *indexPath);

@interface RechargeTableView : BaseTableView

@property (nonatomic, strong) UITextField *moneyTextField;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellBlock:(RechargeCellBlock)cellBlock;

@end
