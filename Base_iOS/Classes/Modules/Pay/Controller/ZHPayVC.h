//
//  ZHPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//  只负责优店支付

#import "TLBaseVC.h"
//#import "ShopVC.h"
#import "ShopModel.h"
#import "ZHPaySceneManager.h"
#import "ZHHZBModel.h"

//typedef NS_ENUM(NSInteger,ZHPayVCType){
//
////    ZHPayVCTypeShop = 0,
////    ZHPayVCTypeGoods //商品购买
//
//};
@interface ZHPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,strong) ShopModel *shop;

//
@property (nonatomic,copy) void(^paySucces)();


@end
