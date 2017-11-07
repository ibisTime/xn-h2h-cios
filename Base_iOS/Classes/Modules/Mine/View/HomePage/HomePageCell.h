//
//  HomePageCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface HomePageCell : UICollectionViewCell

@property (nonatomic, strong) GoodModel *goodModel;

@property (nonatomic, assign) BOOL isCoupon;

@end
