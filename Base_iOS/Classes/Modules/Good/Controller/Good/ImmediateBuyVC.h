//
//  ImmediateBuyVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodModel.h"

//#import "ZHCartGoodsModel.h"

typedef NS_ENUM(NSInteger,IMBuyType){
    
    IMBuyTypeSingle = 0 ,//单个商品
    IMBuyTypeAll, //购物车商品
    
};

@interface ImmediateBuyVC : BaseViewController

@property (nonatomic,assign) IMBuyType type;

//普通商品
@property (nonatomic,strong) GoodModel *good;


//购物车专用
//@property (nonatomic,copy) NSAttributedString *priceAttr;
//@property (nonatomic,copy) NSAttributedString *priceAttrAddPostage;
//
//@property (nonatomic, strong) NSArray <ZHCartGoodsModel *>*cartsRoom;

@property (nonatomic,copy) void(^placeAnOrderSuccess)();

@property (nonatomic, strong) NSNumber *postage;

@end
