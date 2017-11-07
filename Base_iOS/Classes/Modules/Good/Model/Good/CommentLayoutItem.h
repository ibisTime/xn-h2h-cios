//
//  CommentLayoutItem.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/19.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

@interface CommentLayoutItem : NSObject

@property (nonatomic, strong) CommentModel *commentModel;
@property (nonatomic, assign) CGRect commentFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSAttributedString *commentAttrStr;

@property (nonatomic, copy) NSString *comment;

@end
