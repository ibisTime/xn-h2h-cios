//
//  GoodInfoCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "OrderModel.h"

//#import "ZHCartGoodsModel.h"
#import "OrderDetailModel.h"

typedef NS_ENUM(NSInteger, MoneyType) {
    
    MoneyTypeRMB = 0,   //人民币
    MoneyTypeJF,    //积分
};

@interface GoodInfoCell : UITableViewCell

/**
 直接立即购买界面,进入传递该模型
 */
@property (nonatomic,strong) GoodModel *goods;

@property (nonatomic, strong) OrderModel *order;

//币种
@property (nonatomic, assign) MoneyType moneyType;

+ (CGFloat)rowHeight;

@end
