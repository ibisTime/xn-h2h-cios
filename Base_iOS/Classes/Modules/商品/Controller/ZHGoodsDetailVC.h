//
//  ZHGoodsDetailVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//  物品详情

#import "TLBaseVC.h"
#import "GoodModel.h"

typedef NS_ENUM(NSInteger,ZHGoodsDetailType){
    
    ZHGoodsDetailTypeDefault = 0
//    ZHGoodsDetailTypeLookForTreasure
};

@interface ZHGoodsDetailVC : TLBaseVC

//普通商品的模型
@property (nonatomic,strong) GoodModel *goods;

//
@property (nonatomic,assign) ZHGoodsDetailType detailType;


@end
