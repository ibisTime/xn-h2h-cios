//
//  UIScrollView+UITouch.h
//  CarMate
//
//  Created by Sundy on 14-9-1.
//  Copyright (c) 2014年 车友宝(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UITouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
