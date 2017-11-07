//
//  OrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"productOrderList" : [OrderDetailModel class]};
    
}

- (NSString *)getStatusName {

//1 待支付，2 已支付，3 已发货，4 已收货，5 已评论，6 退款申请，7 退款失败，8 退款成功 ，91取消订单
    
    NSDictionary *dict = @{
                           @"1" : @"待支付",
                           @"2" : @"待发货",
                           @"3" : @"待收货",
                           @"4" : @"待评价",
                           @"5" : @"已完成",
                           @"6" : @"退款申请",
                           @"7" : @"退款失败",
                           @"8" : @"退款成功",
                           @"91": @"已取消",
//                           @"92" : @"商户取消",
                           };
    
    return dict[self.status];
    
}

- (NSString *)getSellStatusName {
    
    //1 待支付，2 已支付，3 已发货，4 已收货，5 已评论，6 退款申请，7 退款失败，8 退款成功 ，91取消订单
    
    NSDictionary *dict = @{
                           @"1" : @"待支付",
                           @"2" : @"已支付",
                           @"3" : @"已发货",
                           @"4" : @"已收货",
                           @"5" : @"已卖出",
                           @"6" : @"退款申请",
                           @"7" : @"退款失败",
                           @"8" : @"退款成功",
                           @"91": @"已取消",
                           //                           @"92" : @"商户取消",
                           };
    
    return dict[self.status];
}

@end
