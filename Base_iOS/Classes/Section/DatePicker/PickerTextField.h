//
//  PickerTextField.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountTf.h"

@interface PickerTextField : AccountTf

@property (nonatomic,copy) NSArray *tagNames;

@property (nonatomic,copy)  void (^didSelectBlock)(NSInteger index);

@end
