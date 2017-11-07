//
//  CustomDatePicker.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CustomDatePicker.h"
#import "UIControl+Block.h"

#define kPickerHeight kHeight(349)

@implementation CustomDatePicker

- (instancetype)initWithFrame:(CGRect)frame dateBlock:(SelectedDateBlock)dateBlock {

    if (self = [super initWithFrame:frame]) {
        
        _dateBlock = [dateBlock copy];
        
        [self initTopView];
        
        [self initDatePicker];
    }
    return self;
}

- (void)initTopView {

    BaseWeakSelf;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(45))];
    bgView.backgroundColor = kWhiteColor;
    
    UIButton *completeBtn = [UIButton buttonWithTitle:@"完成" titleColor:kBlackColor backgroundColor:kClearColor titleFont:16.0];
    
    [completeBtn bk_addEventHandler:^(id sender) {
        
        weakSelf.dateBlock(weakSelf.datePicker.date);
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-21);
        make.width.mas_lessThanOrEqualTo(40);
        make.height.mas_lessThanOrEqualTo(30);
        make.centerY.mas_equalTo(0);
        
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kBlackColor backgroundColor:kClearColor titleFont:16.0];
    
    [cancelBtn bk_addEventHandler:^(UIButton *sender) {
        
        [weakSelf hideDatePicker];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(21);
        make.width.mas_lessThanOrEqualTo(40);
        make.height.mas_lessThanOrEqualTo(30);
        make.centerY.mas_equalTo(0);
        
    }];
    
    [self addSubview:bgView];
}

- (void)initDatePicker {
    
    //创建日期选择器
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kHeight(45), kScreenWidth, kHeight(255))];
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDate *loaclDate = [NSString getLocalDate];
    
    NSString *loaclStr = [NSString stringFromDate:loaclDate formatter:@"yyyy-MM-dd"];
    
    NSString *monthStr = [NSString stringFromDate:loaclDate formatter:@"MM-dd"];
    
    NSString *yearStr = [loaclStr substringToIndex:4];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%@", yearStr.integerValue + 1, monthStr];
    
    NSDate *maxDate = [NSString dateFromString:dateStr formatter:@"yyyy-MM-dd"];
    
    NSDate *minDate = [loaclDate dateByAddingTimeInterval:60*60*24*3];
    
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    
    [_datePicker setDate:minDate animated:YES];
    
    _datePicker.backgroundColor = kWhiteColor;
    
    [self addSubview:_datePicker];
    
}

- (void)showDatePicker {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -kPickerHeight);
    }];
}

- (void)hideDatePicker {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    }];
}

@end
