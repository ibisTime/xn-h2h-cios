//
//  GoodListCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/15.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface GoodListCell : UITableViewCell

@property (nonatomic, strong) GoodModel *goodModel;

@property (nonatomic, assign) BOOL isCoupon;

+ (CGFloat)rowHeight;

@end
