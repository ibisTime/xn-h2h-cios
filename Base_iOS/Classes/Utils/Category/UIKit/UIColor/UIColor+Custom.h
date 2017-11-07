//
//  UIColor+Custom.h
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1] 

@interface UIColor (Custom)

/**  app主要颜色，包含:导航栏，底部tabbar等 */
+ (UIColor*)appCustomMainColor;

/**  app主要大部分按钮的背景颜色 */
+ (UIColor*)appButtonBackgroundColor;

//背景颜色
+ (UIColor*)appBackGroundColor;


//16进制转换为UIColor
+ (UIColor*)colorWithHexString:(NSString *)hexString;

+ (UIImage*)createImageWithColor:(UIColor*)color;

//给UIColor添加透明度
+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha;

+ (UIColor *)lineColor;

+ (UIColor *)themeColor;

+ (UIColor *)textColor;

+ (UIColor *)textColor2;

+ (UIColor *)backgroundColor;

+ (UIColor *)zh_themeColor;
+ (UIColor *)zh_textColor;
+ (UIColor *)zh_textColor2;
+ (UIColor *)zh_lineColor;
+ (UIColor *)zh_backgroundColor;

- (UIImage *)convertToImage;

@end


