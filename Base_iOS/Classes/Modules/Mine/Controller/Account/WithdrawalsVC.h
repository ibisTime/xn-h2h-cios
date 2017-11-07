//
//  WithdrawalsVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"

@interface WithdrawalsVC : TLBaseVC

//余额
@property (nonatomic,strong) NSNumber *balance;

@property (nonatomic,strong) void (^success)();

@property (nonatomic,strong) NSString *accountNum;

@end
