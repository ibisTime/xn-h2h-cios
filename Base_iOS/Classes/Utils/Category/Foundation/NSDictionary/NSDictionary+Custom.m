//
//  NSDictionary+Custom.m
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)


+ (NSDictionary *)convertNULLData:(NSDictionary *)sourceDic {

    NSMutableDictionary *mutableDic = nil;
    if ([sourceDic isKindOfClass:[NSNull class]]) {
        mutableDic = nil;
    }
    else {
        mutableDic = [sourceDic mutableCopy];
    }
    
    for (NSString *key in [sourceDic allKeys])
    {
        id value = sourceDic[key];
        if ([value isKindOfClass:[NSNull class]])
        {
            [mutableDic removeObjectForKey:key];
        }
    }
    return mutableDic;
}

- (NSString *)getDictionaryOfSortString {

    NSArray *keyArr = [self allKeys];
    NSArray *arrrayordered =  [keyArr sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *muString = [NSMutableString string];
    for (int i = 0; i < arrrayordered.count; i++) {
        NSString *key = [arrrayordered objectAtIndex:i];
        if (i == arrrayordered.count-1) {
            [muString appendFormat:@"%@=%@",key,[self valueForKey:key]];
        } else
        {
            [muString appendFormat:@"%@=%@&",key,[self valueForKey:key]];
        }
    }
    return muString;
}

- (NSString *)getDictionaryOfPayString {
    
    NSArray *keyArr = [self allKeys];
    NSArray *arrrayordered =  [keyArr sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *muString = [NSMutableString string];
    for (int i = 0; i < arrrayordered.count; i++) {
        NSString *key = [arrrayordered objectAtIndex:i];
        if (i == arrrayordered.count-1) {
            [muString appendFormat:@"%@=\"%@\"",key,[self valueForKey:key]];
        } else
        {
            [muString appendFormat:@"%@=\"%@\"&",key,[self valueForKey:key]];
        }
    }
    return muString;
}

@end
