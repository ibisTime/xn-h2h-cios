//
//  OrderNumberModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/3.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface OrderNumberModel : BaseModel

@property (nonatomic, assign) NSInteger receiveCount;

@property (nonatomic, assign) NSInteger toPayCount;

@property (nonatomic, assign) NSInteger sendCount;

@property (nonatomic, assign) NSInteger payCount;

@end
