//
//  NSString+TextView.m
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/11.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "NSString+TextView.h"

@implementation NSString (TextView)

- (CGFloat)getTextViewHeightForTextWithFont:(float)font size:(CGSize)size {
    
    // UITextView 上下左右各有 8px间距
    
    CGFloat width = size.width - 8*2;
    size = CGSizeMake(width, size.height);
    
    NSString *text = [NSString convertNullOrNil:self];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
    
    
    CGRect frame = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return frame.size.height + 16;
}





@end


