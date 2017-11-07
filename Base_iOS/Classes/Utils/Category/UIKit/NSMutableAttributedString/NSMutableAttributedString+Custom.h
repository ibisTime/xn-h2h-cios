//
//  NSMutableAttributedString+Custom.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelModel.h"

@interface NSMutableAttributedString (Custom)

- (NSMutableAttributedString *)getAttributedStringWithFirstModel:(LabelModel *)firstModel secondModel:(LabelModel *)secondModel;

@end
