//
//  OrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,OrderStatus) {
    
    OrderStatusAllOrder = 0,        //全部
    OrderStatusWillPay = 1,         //待支付
    OrderStatusWillSend = 2,        //待发货
    OrderStatusWillReceipt = 3,     //待收货
    OrderStatusWillComment = 4,     //待评价
    OrderStatusDidComplete = 5,     //已完成
};

@interface OrderListVC : BaseViewController

@property (nonatomic,assign) OrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
