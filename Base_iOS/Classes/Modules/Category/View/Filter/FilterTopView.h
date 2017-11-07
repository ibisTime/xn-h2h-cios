//
//  FilterTopView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterManager.h"
#import "FilterAddressView.h"
#import "FilterCategoryView.h"

typedef NS_ENUM(NSInteger, FilterType) {
    
    FilterTypeArea = 0, //区域
    FilterTypeCategory, //类别
    FilterTypePrice,    //价格
    FilterTypeFilter,   //筛选
};

typedef void(^FilterEventsBlock)();

@interface FilterTopView : UIView
//地址
@property (nonatomic, strong) FilterAddressView *addressView;
//类别
@property (nonatomic, strong) FilterCategoryView *categoryView;

@property (nonatomic, copy) FilterEventsBlock filterBlock;

@end
