//
//  SellFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef NS_ENUM(NSInteger, SellEventsType) {
    
    SellEventsTypeCancel = 0,           //取消订单
    SellEventsTypeConfirmRefund,        //申请退款
    SellEventsTypeSendGood,             //催货
    SellEventsTypeLookComment,          //评价
};

typedef void(^SellEventsBlock)(SellEventsType type);

@interface SellFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) OrderModel *order;

@property (nonatomic, assign) SellEventsType eventsType;

@property (nonatomic, copy) SellEventsBlock sellBlock;

@end
