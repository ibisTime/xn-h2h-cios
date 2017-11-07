//
//  UIColor+Custom.m
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor*)appCustomMainColor {

    static dispatch_once_t onceToken;

    static UIColor *mainColor = nil;
    dispatch_once(&onceToken, ^{
       
        CGFloat r = (arc4random()%200 +50)%200/255.0;
        CGFloat g = (arc4random()%200 +50)%200/255.0;
        CGFloat b = (arc4random()%200 +50)%200/255.0;
        
        mainColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    });
    
    //return mainColor ? mainColor: RGB(200, 220, 81);
//    return RGB(200, 220, 81);1296db
    return [UIColor colorWithHexString:@"#48b0fb"];
}

+ (UIColor*)appButtonBackgroundColor {

    
    static dispatch_once_t onceToken;
    
    static UIColor *btnColor = nil;
    dispatch_once(&onceToken, ^{
        
        CGFloat r = (arc4random()%200 +50)%200/255.0;
        CGFloat g = (arc4random()%200 +50)%200/255.0;
        CGFloat b = (arc4random()%200 +50)%200/255.0;
        
        btnColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    });
    
    //return btnColor ? btnColor: RGB(51, 83, 34);
    return [UIColor colorWithHexString:@"#a21516"];
}

+ (UIColor *)appBackGroundColor {
    
    return RGB(80, 156, 36);
}


+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return [UIColor whiteColor];
    }
    
    //    if ([cString hasPrefix:@"#FF"])
    //    {
    //        cString = [cString substringFromIndex:3];
    //    }
    //    else if ([cString hasPrefix:@"#"])
    //    {
    cString = [cString substringFromIndex:1];
    //    }
    
    if ([cString length] != 6)
    {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *resultColor = RGB(r, g, b);
    
    return resultColor;
}

+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha {

    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)lineColor {
    
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        color = [UIColor colorWithHexString:@"#cccccc"];
    });
    return color;
    
}

+ (UIColor *)themeColor {
    
    //   return  [UIColor colorWithRed:208.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1];
    
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        color = [UIColor colorWithHexString:@"#fe4332"];
    });
    return color;
    
}

+ (UIColor *)textColor {
    
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        color = [UIColor colorWithHexString:@"#484848"];
    });
    return color;
}

+ (UIColor *)textColor2 {
    
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        color = [UIColor colorWithHexString:@"#999999"];
    });
    return color;
}

+ (UIColor *)backgroundColor {
    
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        color = [UIColor colorWithHexString:@"#f0f0f0"];
    });
    return color;
    
}

+ (UIColor *)zh_themeColor {
    
    return [UIColor colorWithHexString:@"#fe4332"];
    
}

+ (UIColor *)zh_textColor {
    
    return [UIColor colorWithHexString:@"#484848"];
}


+ (UIColor *)zh_textColor2 {
    
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)zh_lineColor {
    
    return [UIColor colorWithHexString:@"#eeeeee"];
}

+ (UIColor *)zh_backgroundColor {
    
    return [UIColor colorWithHexString:@"#f0f0f0"];
}

- (UIImage*)convertToImage
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
