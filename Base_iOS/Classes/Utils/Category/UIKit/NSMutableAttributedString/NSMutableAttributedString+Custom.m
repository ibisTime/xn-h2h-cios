//
//  NSMutableAttributedString+Custom.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NSMutableAttributedString+Custom.h"

@implementation NSMutableAttributedString (Custom)

- (NSMutableAttributedString *)getAttributedStringWithFirstModel:(LabelModel *)firstModel secondModel:(LabelModel *)secondModel {

    NSMutableAttributedString *attr1Str = [[NSMutableAttributedString alloc] initWithString:firstModel.text attributes:@{NSFontAttributeName:firstModel.font,NSForegroundColorAttributeName:firstModel.color}];
    
    //--//
    NSAttributedString *attr2Str = [[NSAttributedString alloc] initWithString:secondModel.text attributes:@{NSFontAttributeName:secondModel.font,NSForegroundColorAttributeName:secondModel.color}];
    
    [attr1Str appendAttributedString:attr2Str];
    
    return attr1Str;
}
@end
