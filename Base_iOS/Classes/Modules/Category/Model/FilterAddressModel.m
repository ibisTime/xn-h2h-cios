//
//  FilterAddressModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterAddressModel.h"

@implementation FilterAddressModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"province" : [FilterProvince class]};
}
@end

@implementation FilterProvince

+ (NSDictionary *)objectClassInArray {
    
    return @{@"city" : [FilterCity class]};
}

@end


@implementation FilterCity

+ (NSDictionary *)objectClassInArray {
    
    return @{@"district" : [FilterDistrict class]};
}

@end


@implementation FilterDistrict

@end


