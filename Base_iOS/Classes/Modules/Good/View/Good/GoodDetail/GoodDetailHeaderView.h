//
//  GoodDetailHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface GoodDetailHeaderView : UIView

@property (nonatomic, strong) GoodModel *good;
//浏览量
@property (nonatomic, strong) UILabel *readLbl;

@end
