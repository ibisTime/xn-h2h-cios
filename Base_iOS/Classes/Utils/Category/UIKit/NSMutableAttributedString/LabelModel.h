//
//  LabelModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface LabelModel : BaseModel

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIFont *font;

@end
