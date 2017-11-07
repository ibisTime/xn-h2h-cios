//
//  LayoutHelper.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "LayoutHelper.h"

@implementation LayoutHelper

+ (instancetype)helper {
    
    static LayoutHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[LayoutHelper alloc] init];
        [helper initData];
    });
    
    return helper;
    
    
}

- (void)initData {
    
    self.titleFont = 15;
    self.contentFont = 14;
    
    //
    self.contentLeftMargin = 15;
    self.contentRightMargin = 15;
    
    self.contentWidth = kScreenWidth - self.contentLeftMargin - self.contentRightMargin;
    
    //图片浏览相关
    self.photoMargin = 5;
    self.photoWidth = (self.contentWidth - 2*self.photoMargin)/3.0;
    
    //
    self.likeFont = 15;
    self.commentFont = 14;
    self.likeHeight = 30;
    self.likeMargin = 8;
    self.commentMargin = 3;
    self.commentTopMargin = 5;
    
}

@end
