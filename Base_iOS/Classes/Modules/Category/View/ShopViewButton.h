//
//  ShopViewButton.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopViewButton : UIView

@property (nonatomic,copy)  void(^selected)(NSInteger index);

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) UIButton *funcBtn;

- (instancetype)initWithFrame:(CGRect)frame funcName:(NSString *)funcName;

@end
