//
//  MySellOrderDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface MySellOrderDetailVC : BaseViewController

@property (nonatomic,strong) OrderModel *order;

//取消订单
@property (nonatomic,copy) void(^cancleSuccess)();
//发货
@property (nonatomic,copy) void(^sendGoodSuccess)();
//确认退款
@property (nonatomic,copy) void(^confirmRefundSuccess)();
//查看评价
@property (nonatomic,copy) void(^lookCommentSuccess)();

@end
