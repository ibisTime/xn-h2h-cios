//
//  PickerButton.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PickerButton.h"

#define kPickerHeight kHeight(349)

@interface PickerButton ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,weak) UIPickerView *pickerInput;

@end

@implementation PickerButton

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.tagNames.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return  self.tagNames[row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tagNames.count) {
        
        [self setTitle:self.tagNames[row] forState:UIControlStateNormal];
        
        if (self.didSelectBlock) {
            self.didSelectBlock(row);
        }
        
    }
}


- (void)setTagNames:(NSArray *)tagNames
{
    _tagNames = [tagNames copy];
    
    if (!self.pickerInput) {
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _pickerInput = picker;
        _pickerInput.delegate = self;
        _pickerInput.dataSource = self;
        _pickerInput.backgroundColor = [UIColor whiteColor];
    }
    
    [self.pickerInput reloadAllComponents];
}

- (void)showPicker {

    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -kPickerHeight);
    }];
}

- (void)hidePicker {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    }];
}

@end
