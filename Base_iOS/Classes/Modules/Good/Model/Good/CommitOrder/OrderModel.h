//
//  OrderModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "OrderDetailModel.h"

@interface OrderModel : BaseModel

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *receiver; //收货人
@property (nonatomic,copy) NSString *reMobile; //电话
@property (nonatomic,copy) NSString *reAddress; //地址

@property (nonatomic,copy) NSString *type; //类型
@property (nonatomic,copy) NSString *applyNote; //商家嘱托

//物品数组 <OrderDetailModel *>
@property (nonatomic,copy) NSArray <OrderDetailModel *> *productOrderList;

//0全部 1待支付 2 待发货 3 待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
@property (nonatomic,copy) NSString *status; //状态

@property (nonatomic,copy) NSString *deliveryDatetime; //发货时间
@property (nonatomic,copy) NSString *applyDatetime; //发货时间

@property (nonatomic,copy) NSString *logisticsCode; //快递编号
@property (nonatomic,copy) NSString *logisticsCompany; //快递公司
//下单数量
@property (nonatomic, strong) NSNumber *quantity;

//运费
@property (nonatomic, strong) NSNumber *yunfei;

@property (nonatomic, copy) NSString *toUser;

//规格价格，和规格名称
@property (nonatomic, copy) NSString *productSpecsName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *price2;
@property (nonatomic, strong) NSNumber *price3;
//商品价
@property (nonatomic, strong) NSNumber *amount1;
@property (nonatomic, strong) NSNumber *amount2;
//人民币支付
@property (nonatomic, strong) NSNumber *payAmount1;
//积分支付
@property (nonatomic, strong) NSNumber *payAmount2;
//优惠券支付
@property (nonatomic, strong) NSNumber *payAmount3;

- (NSString *)getStatusName;

- (NSString *)getSellStatusName;

@end
