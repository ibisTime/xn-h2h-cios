//
//  CustomDatePicker.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedDateBlock)(NSDate *date);

@interface CustomDatePicker : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) SelectedDateBlock dateBlock;

- (instancetype)initWithFrame:(CGRect)frame dateBlock:(SelectedDateBlock)dateBlock;

- (void)showDatePicker;

- (void)hideDatePicker;

@end
