//
//  BillModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel

- (NSString *)getBizName {
    NSDictionary *dict = @{
                           
                           @"11" : @"充值",
                           @"-11" : @"提现",
                           @"19": @"蓝补",
                           @"-19" : @"红冲",
                           
                           @"30" : @"购物退款",
                           @"-30" : @"购物",
                           @"32" : @"确认收货",
                           @"80" :@"橙券代销",
                           @"81" :@"积分代发",
                           @"YC_O2O_RMB" :@"姚橙O2O人民币支付",
                           @"YC_O2O_RMBFD" :@"姚橙O2O人民币支付返橙券",
                           @"YC_O2O_CB" :@"姚橙O2O橙券支付",
                           @"YC_O2O_CBFD" : @"姚橙O2O橙券支付返人民币",
                           
                           
                           };
    
    return dict[self.bizType];
    
}
- (CGFloat)dHeightValue {
    
    CGFloat width = kScreenWidth - 15 - 40 - 15 - 36 - 15 - 15;
    
    CGSize size = [self.bizNote calculateStringSize:CGSizeMake(width, MAXFLOAT) font:FONT(14)];
    return size.height - [FONT(14) lineHeight] + 3;
    
}

@end
