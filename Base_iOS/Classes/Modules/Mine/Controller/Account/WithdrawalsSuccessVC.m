//
//  WithdrawalsSuccessVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "WithdrawalsSuccessVC.h"

@interface WithdrawalsSuccessVC ()

@end

@implementation WithdrawalsSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 56, 56)];
    
    iconIV.image = kImage(@"我的_提现成功");
    
    iconIV.centerX = bgView.centerX;
    
    [bgView addSubview:iconIV];
    
    UILabel *textLbl = [UILabel labelWithFrame:CGRectMake(0, iconIV.yy + 26, kScreenWidth, kFontHeight(15.0)) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15.0) textColor:kTextColor];
    
    textLbl.text = @"提现成功";
    
    [bgView addSubview:textLbl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
