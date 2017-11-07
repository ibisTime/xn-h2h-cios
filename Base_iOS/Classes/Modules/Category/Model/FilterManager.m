//
//  FilterManager.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterManager.h"

@implementation FilterManager

+ (instancetype)manager {
    
    static FilterManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FilterManager alloc] init];
    });
    
    return manager;
}

- (void)clearManager {
    
    self.province = nil;
    self.city = nil;
    self.area = nil;
    self.category = nil;
    self.isCategory = NO;
    self.isAsc = NO;
    self.isFreight = NO;
    self.isNew = NO;
    self.maxPrice = nil;
    self.minPrice = nil;
    self.isCoupon = NO;
}

@end
