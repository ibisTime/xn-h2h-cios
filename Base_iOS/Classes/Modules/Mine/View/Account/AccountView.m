//
//  AccountView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountView.h"

@interface AccountView()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *rmbLabel;

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) NSMutableArray <UILabel *>*lbls;

@end

@implementation AccountView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initHeaderView];
        
        [self initBottomView];
    }
    
    return self;
}

#pragma mark - Init

- (void)initHeaderView {
    
    self.backgroundColor = kBackgroundColor;
    
    self.headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    self.headerView.backgroundColor = kAppCustomMainColor;
    
    [self addSubview:self.headerView];
    
    UILabel *textLabel = [UILabel labelWithText:@"账户余额（元）" textColor:kWhiteColor textFont:12];
    
    textLabel.backgroundColor = kClearColor;
    [self.headerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(28);
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(16);
        
    }];
    
    self.rmbLabel = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:36];
    
    self.rmbLabel.backgroundColor = kClearColor;
    self.rmbLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.headerView addSubview:self.rmbLabel];
    [self.rmbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(textLabel.mas_bottom).mas_equalTo(18);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(35);
        
    }];
    
    self.arrowBtn = [UIButton buttonWithImageName:@"更多-白色"];
    
    self.arrowBtn.contentMode = UIViewContentModeScaleToFill;
    
    [self.arrowBtn setEnlargeEdge:20];
    [self.arrowBtn addTarget:self action:@selector(goFlowDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.rmbLabel.mas_top).mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        
    }];
    
    CGFloat h = 40;
    CGFloat w = 120;
    
    //充值
    UIButton *rechargeBtn = [UIButton buttonWithTitle:@"充值" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
    
    rechargeBtn.layer.borderWidth = 1;
    rechargeBtn.layer.borderColor = kWhiteColor.CGColor;
    
    [rechargeBtn addTarget:self action:@selector(rechargeMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_centerX).mas_equalTo(-12.5);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(-28);
        
    }];
    
    //提现
    UIButton *withdrawalsBtn = [UIButton buttonWithTitle:@"提现" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
    
    withdrawalsBtn.layer.borderWidth = 1;
    withdrawalsBtn.layer.borderColor = kWhiteColor.CGColor;
    
    [withdrawalsBtn addTarget:self action:@selector(getMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:withdrawalsBtn];
    [withdrawalsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_centerX).mas_equalTo(12.5);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
        make.bottom.mas_equalTo(-28);
        
    }];
    
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.yy, kScreenWidth, 80)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bottomView];
    
    NSArray *textArr = @[@"消费金额", @"充值金额", @"提现金额"];
    
    self.lbls = [[NSMutableArray alloc] init];

    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //
        CGFloat lblWidth = kScreenWidth/(textArr.count*1.0);
        
        UILabel *numLbl = [UILabel labelWithText:@"--" textColor:kTextColor textFont:18.0];
        
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.backgroundColor = kClearColor;
        [self.bottomView addSubview:numLbl];
        
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(idx*lblWidth);
            make.width.mas_equalTo(lblWidth);
            make.bottom.mas_equalTo(self.bottomView.mas_centerY).mas_equalTo(-5);
            make.height.mas_equalTo(20);
            
        }];
        
        UILabel *textLbl = [UILabel labelWithText:@"" textColor:[UIColor colorWithHexString:@"#666666"] textFont:12.0];
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        textLbl.backgroundColor = kClearColor;
        textLbl.text = textArr[idx];

        [self.bottomView addSubview:textLbl];
        
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(idx*lblWidth);
            make.width.mas_equalTo(lblWidth);
            make.top.mas_equalTo(self.bottomView.mas_centerY).mas_equalTo(5);
            make.height.mas_lessThanOrEqualTo(13);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [self.bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(textLbl.mas_right).mas_equalTo(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(46);
            make.centerY.mas_equalTo(0);
            
        }];
        
        [self.lbls addObject:numLbl];

    }];
}

#pragma mark - Events
- (void)goFlowDetail:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:AccountTypeRMBFlow idx:0];
        
    }
}

- (void)rechargeMoney {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:AccountTypeRecharge idx:0];
        
    }
}

- (void)getMoney {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:AccountTypeWithdrawals idx:0];
        
    }
}

- (void)setRmbText:(NSString *)rmbText {
    
    _rmbText = rmbText;
    
    self.rmbLabel.text = _rmbText;
    
}

- (void)setAccountModel:(AccountInfoModel *)accountModel {
    
    _accountModel = accountModel;
    
    self.lbls[0].text = [_accountModel.outTotalAmount convertToRealMoney];
    self.lbls[1].text = [_accountModel.inTotalAmount convertToRealMoney];
    self.lbls[2].text = [_accountModel.txTotalAmount convertToRealMoney];

}
@end
