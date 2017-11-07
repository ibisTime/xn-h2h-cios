//
//  RechargeActivityModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface RechargeActivityModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *endDatetime;

@property (nonatomic, copy) NSString *startDatetime;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *systemCode;

@end
