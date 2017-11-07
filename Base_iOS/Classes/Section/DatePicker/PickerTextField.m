//
//  PickerTextField.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PickerTextField.h"

@interface PickerTextField ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIPickerView *pickerInput;

@end

@implementation PickerTextField

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
        
        self.text = self.tagNames[row];
        
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
        
        self.inputView = _pickerInput;
//        self.isSecurity = YES;
        self.delegate = self;
    }
    
    [self.pickerInput reloadAllComponents];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (_tagNames.count) {
        
        if (self.text.length == 0) {
            
            self.text = _tagNames[0];

            if (self.didSelectBlock) {
                self.didSelectBlock(0);
            }
        }
        
    }
    
    return YES;
}

@end
