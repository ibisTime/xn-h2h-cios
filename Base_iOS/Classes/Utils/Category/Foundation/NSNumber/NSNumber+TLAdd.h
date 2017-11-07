//
//  NSNumber+TLAdd.h
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/1/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (TLAdd)

//转换金额
- (NSString *)convertToRealMoney;

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney;

- (NSString *)convertToCountMoney;

@end
