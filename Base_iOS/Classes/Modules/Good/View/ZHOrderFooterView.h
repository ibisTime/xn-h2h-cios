//
//  ZHOrderFooterView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef NS_ENUM(NSInteger, OrderEventsType) {
    
    OrderEventsTypePay = 0,             //支付
    OrderEventsTypeCancel,              //取消订单
    OrderEventsTypeApplyRefund,         //申请退款
    OrderEventsTypeUrgeSendGood,        //催货
    OrderEventsTypeConfirmReceiptGood,  //确认收货
    OrderEventsTypeComment,             //评价
};

typedef void(^OrderEventsBlock)(OrderEventsType type);

@interface ZHOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) OrderModel *order;

@property (nonatomic, assign) OrderEventsType eventsType;

@property (nonatomic, copy) OrderEventsBlock orderBlock;

@end
