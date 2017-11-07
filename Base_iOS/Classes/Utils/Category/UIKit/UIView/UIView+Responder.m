//
//  UIView+Responder.m
//  QinMaShangDao
//
//  Created by 蔡卓越 on 15/11/27.
//  Copyright © 2015年 李华光. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)

- (UIViewController *)viewController
{
    UIResponder *responser = [self nextResponder];
    do {
        if ([responser isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responser;
        }
        responser = [responser nextResponder];
    } while (responser != nil);
    return nil;
}

@end
