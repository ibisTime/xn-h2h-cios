//
//  ZHShopOrderModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
//#import "ShopModel.h"

@interface ZHShopOrderModel : TLBaseModel

//@property (nonatomic,copy) NSString *code;
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,strong) NSNumber *amount;
//@property (nonatomic,copy) NSString *createDatetime;
//@property (nonatomic,copy) NSString *storeCode;
//@property (nonatomic,copy) NSString *systemCode;

@property (nonatomic,strong) NSNumber *payAmount2;
@property (nonatomic,strong) NSNumber *payAmount3;

@property (nonatomic,strong) NSNumber *price; //实际消费


@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *jourCode;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *storeCode;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *userId;

//@property (nonatomic,strong) ShopModel *store; //店铺

- (NSString *)getStatusName;

@end
