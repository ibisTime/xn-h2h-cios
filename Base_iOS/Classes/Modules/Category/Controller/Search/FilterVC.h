//
//  FilterVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"
#import "PublishCategoryModel.h"

typedef NS_ENUM(NSInteger, FilterVCType){
    
    FilterVCTypeSearch = 0,   //商品
    FilterVCTypeCategory,     //类别
    FilterVCTypeCouponGood,   //优惠商品
};

typedef void(^ReturnBlock)();

@interface FilterVC : BaseViewController

@property (nonatomic,assign) FilterVCType type;
//搜索内容
@property (nonatomic, copy) NSString *searchText;
//类别名称
@property (nonatomic, strong) PublishCategoryModel *category;

@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *lat;

@property (nonatomic, copy) ReturnBlock returnBlock;

@end
