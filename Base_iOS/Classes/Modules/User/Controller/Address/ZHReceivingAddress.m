//
//  ZHReceivingAddress.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHReceivingAddress.h"

@implementation ZHReceivingAddress

- (NSString *)totalAddress {

    return [[[self.province add:self.city] add:self.district] add:self.detailAddress];

}

- (BOOL)isSelected {
    
    return [self.isDefault isEqualToString:@"1"] ? YES: NO;
    
}

@end
