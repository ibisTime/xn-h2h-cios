//
//  GoodDetailLayoutItem.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayoutHelper.h"

#import "GoodModel.h"

@interface GoodDetailLayoutItem : NSObject

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) GoodModel *good;

@end
