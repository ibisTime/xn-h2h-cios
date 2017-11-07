//
//  ZHOrderGoodsCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "ZHCartGoodsModel.h"
#import "ZHOrderDetailModel.h"
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, MoneyType) {

    MoneyTypeRMB = 0,   //人民币
    MoneyTypeJF,    //积分
};

@class ZHOrderModel;

// 购物清单cell  立刻支付中的cell
//订单cell
@interface ZHOrderGoodsCell : UITableViewCell

/**
 直接立即购买界面,进入传递该模型
 */
@property (nonatomic,strong) GoodModel *goods;

@property (nonatomic, strong) ZHOrderModel *order;

/**
 从购物清单列表进入传入该模型
 */
@property (nonatomic, strong) ZHCartGoodsModel *cartGoodsModel;

@property (nonatomic,copy) void(^comment)(NSString *code);

//币种
@property (nonatomic, assign) MoneyType moneyType;

+ (CGFloat)rowHeight;

@end
