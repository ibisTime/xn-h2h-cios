//
//  OrderDetailModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface OrderDetailModel : BaseModel

@property (nonatomic, copy, readonly) NSString *productName;

@property (nonatomic, copy) NSString *productSpecsName;

@property (nonatomic, copy) NSString *productDescription;

@property (nonatomic, copy, readonly) NSString *productPic;

@property (nonatomic,strong) NSNumber *quantity; //数量

@property (nonatomic, strong) NSDictionary *product;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *orderCode;

@property (nonatomic,strong) NSNumber *price1;
@property (nonatomic,strong) NSNumber *price2;
@property (nonatomic,strong) NSNumber *price3;

@property (nonatomic,copy) NSString *productCode;


@end
