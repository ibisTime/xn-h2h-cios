//
//  OrderGoodsCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

#import "OrderDetailModel.h"

typedef NS_ENUM(NSInteger, MoneyType) {
    
    MoneyTypeRMB = 0,   //人民币
    MoneyTypeJF,    //积分
};

@interface OrderGoodsCell : UITableViewCell

@property (nonatomic, strong) OrderModel *order;
//币种
@property (nonatomic, assign) MoneyType moneyType;

+ (CGFloat)rowHeight;

@end
