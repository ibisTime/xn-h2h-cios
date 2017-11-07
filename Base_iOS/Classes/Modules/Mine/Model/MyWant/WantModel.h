//
//  WantModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class WantProduct;
@interface WantModel : BaseModel

@property (nonatomic, copy) NSString *interacter;

@property (nonatomic, strong) WantProduct *product;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *interactDatetime;

@property (nonatomic, copy) NSString *entityCode;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *systemCode;

@end
@interface WantProduct : NSObject

@property (nonatomic, copy) NSString *isJoin;

@property (nonatomic, strong) NSNumber *yunfei;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, strong) NSNumber *originalPrice;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *isNew;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) NSNumber *discount;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *publishDatetime;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic,copy) NSArray *pics;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *isPublish;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSNumber *boughtCount;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *desc;

@end

