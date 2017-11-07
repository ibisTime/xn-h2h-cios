//
//  TextView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLComposeTextView.h"

@interface TextView : UIView

//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) TLComposeTextView *textView;

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder;
@end
