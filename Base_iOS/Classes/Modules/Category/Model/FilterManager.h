//
//  FilterManager.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "PublishCategoryModel.h"

@interface FilterManager : BaseModel
//选择的地址
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//区
@property (nonatomic, strong) NSString *area;
//分类
@property (nonatomic, strong) PublishCategoryModel *category;
//区分大小类
@property (nonatomic, assign) BOOL isCategory;
//价格升降
@property (nonatomic, assign) BOOL isAsc;
//包邮
@property (nonatomic, assign) BOOL isFreight;
//全新
@property (nonatomic, assign) BOOL isNew;
//最高价
@property (nonatomic, copy) NSString *maxPrice;
//最低价
@property (nonatomic, copy) NSString *minPrice;
//优惠活动
@property (nonatomic, assign) BOOL isCoupon;

+ (instancetype)manager;

//清空
- (void)clearManager;

@end
