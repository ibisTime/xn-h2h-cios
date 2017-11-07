//
//  GoodDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,GoodsDetailType){
    
    GoodsDetailTypeDefault = 0, //商品列表进入
    GoodsDetailTypeMyPublish,   //我卖出的
};

@interface GoodDetailVC : BaseViewController
//宝贝编号
@property (nonatomic, copy) NSString *code;
//发布人ID
@property (nonatomic, copy) NSString *userId;
//
@property (nonatomic,assign) GoodsDetailType detailType;

@end
