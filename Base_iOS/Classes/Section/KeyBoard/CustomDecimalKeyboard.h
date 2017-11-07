//
//  CustomDecimalKeyboard.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDecimalKeyboard : UIView

@property (copy, nonatomic, nullable) void (^done)();       /*< 点击确定执行的回调 */
@property (nonatomic) UIColor *tintColor;                   /*< 主色调（针对确定按钮） */
@property (copy, nonatomic, nullable) BOOL (^shouldInput)(id<UIKeyInput> inputView);

- (instancetype)initWithTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
