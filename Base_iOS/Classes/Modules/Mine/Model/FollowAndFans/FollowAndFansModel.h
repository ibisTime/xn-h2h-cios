//
//  FollowAndFansModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface FollowAndFansModel : BaseModel

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, assign) BOOL tradepwdFlag;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *updater;

@end
