//
//  UIView+Custom.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)
//制作半圆
- (CALayer *)getLayerWithDirection:(NSString *)direction size:(CGSize)size;

//画一条线
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//画整个视图
- (void)drawAroundLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//画半个视图
- (void)drawHalfAroundLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


- (UIView*)subViewOfClassName:(NSString*)className;

@end
