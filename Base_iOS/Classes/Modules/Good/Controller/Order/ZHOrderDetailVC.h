//
//  ZHOrderDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "OrderModel.h"

@interface ZHOrderDetailVC : TLBaseVC

@property (nonatomic,strong) OrderModel *order;
//支付
@property (nonatomic,copy) void(^paySuccess)();
//取消订单
@property (nonatomic,copy) void(^cancleSuccess)();
//申请退款
@property (nonatomic,copy) void(^refundSuccess)();
//评价
@property (nonatomic,copy) void(^commentSuccess)();
//收货
@property (nonatomic,copy) void(^confirmReceiveSuccess)();

@end
