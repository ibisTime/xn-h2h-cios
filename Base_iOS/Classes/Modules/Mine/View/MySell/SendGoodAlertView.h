//
//  SendGoodAlertView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPickerTextField.h"
#import "ExpressModel.h"

typedef void(^ConfirmBlock)(ExpressModel *expressModel, NSString *expressNum);

typedef void(^CancelBlock)();

@interface SendGoodAlertView : UIView

@property (nonatomic,strong) TLPickerTextField *expressPicker;

@property (nonatomic,strong) UITextField *expressNumTF;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, strong) NSArray <ExpressModel *>*expressArr;

@property (nonatomic, strong) ExpressModel *expressModel;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
