//
//  WithdrawalsVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "WithdrawalsVC.h"
#import "TLPickerTextField.h"
#import "ZHBankCardAddVC.h"
#import "TLPwdRelatedVC.h"
#import "DetailWebView.h"
#import "WithdrawalsSuccessVC.h"
#import "KeyValueModel.h"

@interface WithdrawalsVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) TLPickerTextField *bankPickTf;
@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic,strong) UITextField *moneyTf;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,strong) TLTextField *chargeFeeTF;
@property (nonatomic,strong) TLTextField *tradePwdTf;

//提现手续费率
@property (nonatomic, copy) NSString *cuserqxfl;
//每月最大提现次数
@property (nonatomic, copy)  NSString *monTimes;
//倍数
@property (nonatomic, copy)  NSString *bs;
//单笔最高
@property (nonatomic, copy)  NSString *dbzg;
//到账时间
@property (nonatomic, copy) NSString *dzsj;

@property (nonatomic, strong) DetailWebView *detailWebView;

@property (nonatomic, copy) NSString *withdrawalsRule;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*models;

@property (nonatomic, strong) UILabel *ruleLbl;

@end

@implementation WithdrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"提现"];
    
    [self beginLoad];
    
}

#pragma mark- 站位图行为
- (void)tl_placeholderOperation {
    
    BaseWeakSelf;
    
    ZHBankCardAddVC *addVC = [[ZHBankCardAddVC alloc] init];
    
    addVC.title = @"添加银行卡";

    addVC.addSuccess = ^(ZHBankCard *card){
        
        [weakSelf beginLoad];
        
    };
    
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark- 设置交易密码
- (void)setTrade:(UIButton *)btn {
    
    TLPwdType pwdType = [[TLUser user].tradepwdFlag isEqualToString:@"0"] ? TLPwdTypeSetTrade: TLPwdTypeTradeReset;

    TLPwdRelatedVC *tradeVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
    
    tradeVC.success = ^() {
        
        btn.hidden = YES;
        
    };
    [self.navigationController pushViewController:tradeVC animated:YES];
    
}

#pragma mark - Setting
//- (void)setWithdrawalsRule:(NSString *)withdrawalsRule {
//
//    _withdrawalsRule = withdrawalsRule;
//
//    //打款指引
//    [self initWebview];
//}

#pragma mark - Init
- (void)setUpUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight)];
    
    self.scrollView.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.scrollView];
    
    //银行卡
    self.bankPickTf = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)
                                                     leftTitle:@"银行卡"
                                                    titleWidth:90
                                                   placeholder:@"请选择银行卡"];
    
    [self.scrollView addSubview:self.bankPickTf];
    self.bankPickTf.isSecurity = YES;
    
    //背景
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:bgView];
    
    //提现金额
    
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 300, [Font(15) lineHeight]) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(15) textColor:kTextColor];
    hintLbl.text = @"提现金额";
    [bgView addSubview:hintLbl];
    
    //remark
    UILabel *markLbl = [UILabel labelWithFrame:CGRectMake(10, hintLbl.yy + 28, 30, 40) textAligment:NSTextAlignmentLeft backgroundColor:kWhiteColor font:Font(30) textColor:kTextColor4];
    
    [bgView addSubview:markLbl];
    markLbl.text = @"￥";
    markLbl.height = [Font(30) lineHeight];
    
    //提现金额
    TLTextField *withdrawaksTf = [[TLTextField alloc] initWithFrame:CGRectMake(markLbl.xx, hintLbl.yy + 28, kScreenWidth - markLbl.xx, [Font(30) lineHeight]) leftTitle:@"" titleWidth:0 placeholder:@"0.00"];
    
    withdrawaksTf.font = Font(30);
    withdrawaksTf.keyboardType = UIKeyboardTypeNumberPad;
    
    [withdrawaksTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgView addSubview:withdrawaksTf];
    self.moneyTf = withdrawaksTf;

    self.balanceLbl = [UILabel labelWithFrame:CGRectMake(15, withdrawaksTf.yy + 28, 200, [Font(14.0) lineHeight]) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(14.0) textColor:kAppCustomMainColor];
    
    [bgView addSubview:self.balanceLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.balanceLbl.yy + 15, kScreenWidth, 1)];
    
    line.backgroundColor = kLineColor;
    
    [bgView addSubview:line];
    
    //手续费
    TLTextField *chargeFeeTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, line.yy , kScreenWidth, 50) leftTitle:@"本次提现手续费" titleWidth:130 placeholder:@"0.00元"];
    
    chargeFeeTf.textColor = kAppCustomMainColor;
    
    [bgView addSubview:chargeFeeTf];
    
    self.chargeFeeTF = chargeFeeTf;
    
    bgView.frame = CGRectMake(0, self.bankPickTf.yy + 10, kScreenWidth, chargeFeeTf.yy);
    
    //支付密码
    
    TLTextField *tradePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, bgView.yy + 10, kScreenWidth, 50) leftTitle:@"支付密码" titleWidth:90 placeholder:@"请输入支付密码"];
    tradePwdTf.secureTextEntry = YES;
    tradePwdTf.isSecurity = YES;
    [self.scrollView addSubview:tradePwdTf];
    self.tradePwdTf = tradePwdTf;
    
    UIButton *withdrawalBtn = [UIButton buttonWithTitle:@"提现" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    withdrawalBtn.frame = CGRectMake(15, tradePwdTf.yy + 50, kScreenWidth - 30, 45);
    
    [withdrawalBtn addTarget:self action:@selector(withdrawal) forControlEvents:UIControlEventTouchUpInside];

    withdrawalBtn.tag = 1200;
    
    [self.scrollView addSubview:withdrawalBtn];
    
    self.ruleLbl = [UILabel labelWithFrame:CGRectMake(15, withdrawalBtn.yy + 15, kScreenWidth - 2*15, 100) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(13.0) textColor:kTextColor2];
    
    self.ruleLbl.numberOfLines = 0;
    
    [self.scrollView addSubview:self.ruleLbl];
    
    self.scrollView.contentSize =CGSizeMake(kScreenWidth, self.ruleLbl.yy + 20);

    //
    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, tradePwdTf.yy + 10, kScreenWidth - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
    setPwdBtn.titleLabel.font = Font(13);
    [setPwdBtn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollView addSubview:setPwdBtn];

    //给初始化数据
    self.balanceLbl.text = [NSString stringWithFormat:@"可提现金额%@元", [self.balance convertToRealMoney]];
    
    //取出银行卡
    NSMutableArray *bankCards = [NSMutableArray arrayWithCapacity:self.banks.count];
    
    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bankCards addObject:obj.bankcardNumber];
    }];
    
    self.bankPickTf.tagNames = bankCards;
    
    if (bankCards.count > 0) {
        
        self.bankPickTf.text = bankCards[0];

    }
 
    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
        
        setPwdBtn.hidden = YES;
    }
}

- (void)initRuleLbl {
    
    
}

- (void)initWebview {
    
    BaseWeakSelf;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:1200];
    
    //账号信息
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, btn.yy + 16, kScreenWidth, 100)];
    
    [self.detailWebView loadWebWithString:_withdrawalsRule];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        weakSelf.detailWebView.height = height;
        
        weakSelf.detailWebView.webView.height = height;
//        //底部按钮
//        [weakSelf initBottomButton];
    };
    
    [self.scrollView addSubview:weakSelf.detailWebView];
    
}

#pragma mark - Data
- (void)beginLoad {
    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802016";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *banks = responseObject[@"data"];
        
        if (banks.count > 0) {
            
            [self removePlaceholderView];
            
            self.banks = [ZHBankCard tl_objectArrayWithDictionaryArray:banks];
            
            [self setUpUI];
            
            [self requestWithdrawalsRule];
            
        } else { //无卡
            
            [self setPlaceholderViewTitle:@"您还未添加银行卡" operationTitle:@"前往添加"];
            [self addPlaceholderView];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestWithdrawalsRule {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802025";
    
    helper.parameters[@"type"] = @"3";
    
    [helper modelClass:[KeyValueModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.models = objs;
        
        [weakSelf.models enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.ckey isEqualToString:@"CUSERMONTIMES"]) {
                
                self.monTimes = obj.cvalue;
                
            } else if ([obj.ckey isEqualToString:@"CUSERQXBS"]) {
                
                self.bs = obj.cvalue;

            } else if ([obj.ckey isEqualToString:@"CUSERDZTS"]) {
                
                self.dzsj = obj.cvalue;

            } else if ([obj.ckey isEqualToString:@"QXDBZDJE"]) {
                
                self.dbzg = obj.cvalue;

            } else if ([obj.ckey isEqualToString:@"CUSERQXFL"]) {
                //提现手续费率
                self.cuserqxfl = obj.cvalue;
                
            }
            
        }];
        //提现手续费率
        CGFloat cuserqxfl = [self.cuserqxfl doubleValue]*100;
        
        NSString *contentStr = [NSString stringWithFormat:@"取现规则: \n1.每月最大提现次数%@次\n2.提现金额必须是%@的倍数, 单笔最高%@元\n3.T+%@到账\n4.提现费率%lg%%", self.monTimes, self.bs, self.dbzg, self.dzsj, cuserqxfl];
        
        [self.ruleLbl labelWithTextString:contentStr lineSpace:5];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Events

- (void)withdrawal {
    
    if(![self.moneyTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入提现金额"];
        return;
        
    }
    //
    if ([self.moneyTf.text greaterThan:self.balance]) {
        
        [TLAlert alertWithInfo:@"余额不足"];
        return;
    }
    
    if (![self.bankPickTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择银行卡"];
        return;
    }
    
    if (![self.tradePwdTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入支付密码"];
        return;
    }
    
    NSString *cardInfo = @"1";
    
    if (self.banks.count > 0) {
        
        ZHBankCard *card = self.banks[0];

        cardInfo = card.bankName;
        
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802750";
    http.parameters[@"token"] = [TLUser user].token;
    
    http.parameters[@"accountNumber"] = self.accountNum;
    //
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];   //@"-100";
    //银行卡号
    http.parameters[@"payCardNo"] = self.bankPickTf.text; //开户行信息
    http.parameters[@"payCardInfo"] = cardInfo;
    
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"applyNote"] = @"用户端取现";
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;

    [http postWithSuccess:^(id responseObject) {
        
        WithdrawalsSuccessVC *successVC = [WithdrawalsSuccessVC new];
        
        [self.navigationController pushViewController:successVC animated:YES];
        
//        [TLAlert alertWithSucces:@"申请成功,我们将会对该交易进行审核"];
//        [self.navigationController popViewControllerAnimated:YES];
//        if (self.success) {
//            self.success();
//        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)textDidChange:(UITextField *)sender {
    
    if (!sender.text && sender.text.length <= 0) {
        
        self.chargeFeeTF.text = @"0.00元";
        return ;
    }
    
    CGFloat price = [sender.text doubleValue]*[self.cuserqxfl doubleValue];
    
    price = round(price*1000)/1000;
    
    //小数点进1
    
    long long m = price*1000;
    
    if (m%10 > 0) {
        
        price = ceil(price*100)/100;
        
    }
    
    NSString *countPrice = [NSString stringWithFormat:@"%.2f元", price];
    
    self.chargeFeeTF.text = countPrice;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
