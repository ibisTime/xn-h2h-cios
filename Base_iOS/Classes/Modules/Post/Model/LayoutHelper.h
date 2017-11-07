//
//  LayoutHelper.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutHelper : NSObject

@property (nonatomic, assign) CGFloat titleFont;
@property (nonatomic, assign) CGFloat contentFont;

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentLeftMargin;
@property (nonatomic, assign) CGFloat contentRightMargin;


//单个图片宽度
@property (nonatomic, assign) CGFloat photoWidth;
@property (nonatomic, assign) CGFloat photoMargin;

//评论和点赞
@property (nonatomic, assign) CGFloat likeFont;
@property (nonatomic, assign) CGFloat commentFont;
@property (nonatomic, assign) CGFloat likeMargin;
@property (nonatomic, assign) CGFloat likeHeight;

@property (nonatomic, assign) CGFloat commentMargin;

@property (nonatomic, assign) CGFloat commentTopMargin;

+ (instancetype)helper;

@end
