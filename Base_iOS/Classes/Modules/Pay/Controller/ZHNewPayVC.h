//
//  ZHNewPayVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ZHPaySceneManager.h"

//正汇系统无人民币概念
typedef NS_ENUM(NSInteger,ZHPayViewCtrlType){
    
    //分润可以购买
    ZHPayViewCtrlTypeHZB = 0, //汇赚宝
    
    //无人民币支付，，即无微信和支付宝
    ZHPayViewCtrlTypeNewYYDB, //2.0版本的一元夺宝
    
    //各种都有
    ZHPayViewCtrlTypeNewGoods //购物车支付 和 单个商品支付
    
};

@interface ZHNewPayVC : TLBaseVC

//优店支付所需要的模型
@property (nonatomic,assign) ZHPayViewCtrlType type;

//
@property (nonatomic,copy) void(^paySucces)();

//各种总金额----富文本
@property (nonatomic,copy) NSAttributedString *amoutAttr;

//加上邮费的金额
@property (nonatomic,copy) NSAttributedString *amoutAttrAddPostage;

//人民币价格，商品为币种组合可能包含人民币。 小目标为单一币种，可能是人民币标价
@property (nonatomic,strong) NSNumber *rmbAmount;

//商品支付
@property (nonatomic, copy) NSArray <NSString *>*goodsCodeList;

//邮费
@property (nonatomic, strong) NSNumber *postage;


@end
