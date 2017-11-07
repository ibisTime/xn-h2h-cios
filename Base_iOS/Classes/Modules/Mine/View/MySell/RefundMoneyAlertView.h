//
//  RefundMoneyAlertView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/3.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPickerTextField.h"

typedef void(^ConfirmRefundBlock)(NSString *result, NSString *remark);

@interface RefundMoneyAlertView : UIView

@property (nonatomic,strong) TLPickerTextField *refundPicker;

@property (nonatomic,strong) UITextField *remarkTF;

@property (nonatomic, copy) ConfirmRefundBlock confirmBlock;


//显示
- (void)show;

//隐藏
- (void)hide;

@end
