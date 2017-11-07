//
//  SendGoodAlertView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SendGoodAlertView.h"

@interface SendGoodAlertView ()

@property(nonatomic,strong)UIView *bgView;

@end

@implementation SendGoodAlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
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
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 280)/2.0, kHeight(200), 280, 150)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    
    //物流公司
    TLPickerTextField *expressPicker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 10, self.width - 15, 45) leftTitle:@"物流公司: " titleWidth:90 placeholder:@"请选择物流公司"];
    
    expressPicker.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.expressModel = weakSelf.expressArr[index];
        
    };
    
    [self.bgView addSubview:expressPicker];
    self.expressPicker = expressPicker;
    
    //物流单号
    TLTextField *expressNumTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, expressPicker.yy, self.bgView.width - 15, 45) leftTitle:@"物流单号: " titleWidth:90 placeholder:@"请输入物流单号"];
    
    [self.bgView addSubview:expressNumTF];
    self.expressNumTF = expressNumTF;
    //横线
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, expressNumTF.yy + 10, self.bgView.width, 0.5)];
    
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
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"发货" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:16.0];
    
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

    if (_cancelBlock) {
        
        _cancelBlock();
    }
}

-(void)clickConfirm:(UIButton *)sender
{
    if (_confirmBlock) {
        
        _confirmBlock(self.expressModel, self.expressNumTF.text);
    }
    
}

- (void)setExpressArr:(NSArray<ExpressModel *> *)expressArr {
    
    _expressArr = expressArr;
    
    NSMutableArray *tagNames = [NSMutableArray array];
    
    [expressArr enumerateObjectsUsingBlock:^(ExpressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tagNames addObject:obj.dvalue];
        
    }];
    
    self.expressPicker.tagNames = tagNames;
    
}
@end
