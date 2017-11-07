//
//  RefundMoneyAlertView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/3.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RefundMoneyAlertView.h"

@interface RefundMoneyAlertView ()

@property(nonatomic,strong)UIView *bgView;

@property (nonatomic, strong) NSArray *tagNams;

@property (nonatomic, strong) NSString *selectTag;

@end

@implementation RefundMoneyAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.tagNams = @[@"通过", @"不通过"];
        
        [self createView];
    }
    return self;
}

-(void)createView
{
    BaseWeakSelf;
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    //背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2.0, kHeight(200), 280, 180)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    //退款审核
    UILabel *textLbl = [UILabel labelWithText:@"退款审核" textColor:kTextColor2 textFont:16.0];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.frame = CGRectMake(0, 0, self.bgView.width, 50);
    
    [self.bgView addSubview:textLbl];
    
    //物流公司
    TLPickerTextField *refundPicker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, textLbl.yy, self.width - 15, 45) leftTitle:@"是否通过: " titleWidth:90 placeholder:@"请选择结果"];
    
    refundPicker.tagNames = self.tagNams;
    
    refundPicker.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.selectTag = weakSelf.tagNams[index];
        
    };
    
    refundPicker.layer.borderWidth = 0.5;
    refundPicker.layer.borderColor = kLineColor.CGColor;
    
    [self.bgView addSubview:refundPicker];
    self.refundPicker = refundPicker;
    
    //物流单号
    TLTextField *remarkTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, refundPicker.yy, self.bgView.width - 15, 45) leftTitle:@"备注: " titleWidth:90 placeholder:@"请输入备注"];
    
    [self.bgView addSubview:remarkTF];
    self.remarkTF = remarkTF;
    //横线
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, remarkTF.yy, self.bgView.width, 0.5)];
    
    hLine.backgroundColor = kLineColor;
    
    [self.bgView addSubview:hLine];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(self.bgView.width/2.0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(hLine.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(0);
        
    }];
    
    //竖线
    UIView *vLine = [[UIView alloc] init];
    
    vLine.backgroundColor = kLineColor;
    
    [self.bgView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cancelBtn.mas_right).mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(0.5);
        make.top.mas_equalTo(hLine.mas_bottom).mas_equalTo(0);
    }];
    
    //发货
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:16.0];
    
    [confirmBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(self.bgView.width/2.0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(hLine.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(vLine.mas_right).mas_equalTo(0);
        
    }];
    
}

#pragma mark ====展示view
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - Events
-(void)clickCancel:(UIButton *)sender
{
    [self hide];
}

-(void)clickConfirm:(UIButton *)sender
{
    NSString *result = [_selectTag isEqualToString:@"通过"] ? @"1": @"0";
    
    if (_confirmBlock) {
        
        _confirmBlock(result, _remarkTF.text);
    }
    
}

@end
