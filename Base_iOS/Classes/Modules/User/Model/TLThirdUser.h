//
//  TLThirdUser.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLThirdUser : TLBaseModel

@property (nonatomic, copy) NSString *nickname;     //昵称

@property (nonatomic, copy) NSString *iconUrl;      //头像

@property (nonatomic, copy) NSString *unionGender;  //性别

@end
