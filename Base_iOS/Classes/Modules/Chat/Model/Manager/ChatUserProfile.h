//
//  ChatUserProfile.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/31.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ChatUserProfile : BaseModel
//我的头像
@property (nonatomic, copy) NSString *minePhoto;
//对方的头像
@property (nonatomic, copy) NSString *friendPhoto;
//对面的昵称
@property (nonatomic, strong) NSString *friendNickName;

+ (instancetype)sharedUser;

@end
