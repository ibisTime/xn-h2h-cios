//
//  PriceModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PriceModel : BaseModel

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *originPrice;

@property (nonatomic, copy) NSString *freightFee;
//包邮
@property (nonatomic, assign) BOOL isFreight;

@end
