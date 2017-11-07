//
//  CouponModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CouponModel : BaseModel


@property (nonatomic, copy) NSString *toUser;

@property (nonatomic, strong) NSNumber *parValue;

@property (nonatomic, copy) NSString *endDatetime;

@property (nonatomic, copy) NSString *useRange;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *releaser;

@property (nonatomic, copy) NSString *releaseDatetime;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *startDatetime;


@end
