//
//  PickerButton.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerButton : UIButton

@property (nonatomic,copy) NSArray *tagNames;

@property (nonatomic,copy)  void (^didSelectBlock)(NSInteger index);

- (void)showPicker;

- (void)hidePicker;

@end
