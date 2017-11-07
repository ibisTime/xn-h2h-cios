//
//  ActivityModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *endDatetime;

@property (nonatomic, copy) NSString *startDatetime;

@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger value3;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger value2;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSInteger value1;

@end
