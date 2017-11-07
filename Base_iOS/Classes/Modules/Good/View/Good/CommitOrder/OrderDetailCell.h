//
//  OrderDetailCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"
#import "OrderDetailModel.h"

@interface OrderDetailCell : UITableViewCell

@property (nonatomic, strong) OrderModel *order;

+ (CGFloat)rowHeight;

@end
