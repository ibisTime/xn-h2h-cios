//
//  CALayer+CGColor.m
//  BS
//
//  Created by 张阳 on 16/4/11.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "CALayer+CGColor.h"

@implementation CALayer (CGColor)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
