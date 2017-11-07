//
//  AccountInfoModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface AccountInfoModel : BaseModel
//充值金额
@property (nonatomic, strong) NSNumber *inTotalAmount;
//最近一笔提现
@property (nonatomic, assign) NSInteger zjCash;
//已消费金额
@property (nonatomic, strong) NSNumber *outTotalAmount;
//最近一笔消费
@property (nonatomic, assign) NSInteger zjConsume;
//已提现金额
@property (nonatomic, strong) NSNumber *txTotalAmount;

@end
