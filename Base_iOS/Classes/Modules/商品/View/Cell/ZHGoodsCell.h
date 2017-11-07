//
//  ZHGoodsCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface ZHGoodsCell : UITableViewCell

@property (nonatomic,strong) GoodModel *goods;

+ (CGFloat)rowHeight;

@end
