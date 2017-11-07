//
//  NSDictionary+Custom.h
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Custom)


//处理字典为NULL和字典元素为NULL情况

+ (NSDictionary *)convertNULLData:(NSDictionary *)sourceDic;


//字典转化为字符串
- (NSString *)getDictionaryOfSortString;
//支付宝参数
- (NSString *)getDictionaryOfPayString;

@end
