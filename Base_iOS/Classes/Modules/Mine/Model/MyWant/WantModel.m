//
//  WantModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "WantModel.h"

@implementation WantModel

@end
@implementation WantProduct

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }
    
    return _pics;
    
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

@end


