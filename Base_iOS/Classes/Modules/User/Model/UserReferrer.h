//
//  UserReferrer.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/6.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@class ReferrerUserExt;

@interface UserReferrer : BaseModel

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *userReferee;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, assign) NSInteger totalFansNum;

@property (nonatomic, strong) ReferrerUserExt *userExt;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, assign) NSInteger totalFollowNum;

@property (nonatomic, copy) NSString *kind;

@end

@interface ReferrerUserExt : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *userReferee;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *province;

@end

