//
//  RechargeVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "RechargeVC.h"
#import "RechargeTableView.h"

#import "NSDictionary+Custom.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "TLWXManager.h"
#import "TLAlipayManager.h"

#define PAY_TYPE_WX_PAY_CODE @"0"
#define PAY_TYPE_ALI_PAY_CODE @"1"
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface RechargeVC ()<WXApiDelegate, UITextFieldDelegate>
//
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic,strong) UITextField *moneyTf;

@property (nonatomic, strong) RechargeTableView *tableView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) NSInteger payType;

@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel labelWithTitle:@"充值"];
    
    [self initTableView];

    [self initHeaderView];
    
    [self initFooterView];
}

#pragma mark - Init

- (void)initHeaderView {
    
    //背景
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    self.headerView = bgView;
    
    //充值金额
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 300, [Font(15) lineHeight]) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(15) textColor:kTextColor];
    hintLbl.text = @"充值金额";
    [bgView addSubview:hintLbl];
    
    //remark
    UILabel *markLbl = [UILabel labelWithFrame:CGRectMake(10, hintLbl.yy + 28, 30, 40) textAligment:NSTextAlignmentLeft backgroundColor:kWhiteColor font:Font(30) textColor:kTextColor4];
    
    [bgView addSubview:markLbl];
    markLbl.text = @"￥";
    markLbl.height = [Font(30) lineHeight];
    
    //充值金额
    TLTextField *withdrawaksTf = [[TLTextField alloc] initWithFrame:CGRectMake(markLbl.xx, hintLbl.yy + 28, kScreenWidth - markLbl.xx, [Font(30) lineHeight]) leftTitle:@"" titleWidth:0 placeholder:@"0.00"];
    
    withdrawaksTf.font = Font(30);
    withdrawaksTf.keyboardType = UIKeyboardTypeDecimalPad;
    withdrawaksTf.delegate = self;
    
    [bgView addSubview:withdrawaksTf];
    self.moneyTf = withdrawaksTf;
    
    //底部分割线
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, withdrawaksTf.yy + 28, kScreenWidth, 10)];
    topLine.backgroundColor = kBackgroundColor;
    [bgView addSubview:topLine];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付方式";
    label.font = Font(12.0);
    label.textColor = [UIColor textColor2];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(topLine.mas_bottom).mas_equalTo(0);
    }];
    
    //底部分割线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, withdrawaksTf.yy + 68, kScreenWidth, 1)];
    bottomLine.backgroundColor = kLineColor;
    [bgView addSubview:bottomLine];
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, bottomLine.yy);
    
    self.tableView.tableHeaderView = self.headerView;

}

- (void)initTableView {
    
    BaseWeakSelf;

    self.payType = 10;
    
    self.tableView = [[RechargeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped cellBlock:^(NSIndexPath *indexPath) {
        
        weakSelf.payType = indexPath.row;
        
    }];
    
    [self.view addSubview:self.tableView];
}

- (void)initFooterView {
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _footerView.backgroundColor = [UIColor clearColor];
    //充值
    UIButton *rechargeBtn = [UIButton buttonWithTitle:@"充值" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    [rechargeBtn addTarget:self action:@selector(clickRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    _tableView.tableFooterView = _footerView;
}

#pragma mark - Events
- (void)clickRecharge {
    
    [self.view endEditing:YES];
    
    CGFloat rechargeMoney = [NSString stringWithFormat:@"%@",self.moneyTf.text].doubleValue;
    
    NSString *promptStr = @"";
    
    if (rechargeMoney <= 0) {
        
        promptStr = @"请充值大于0的金额";
        
        [TLAlert alertWithInfo:promptStr];
        
        return ;
    }
    
//    if (self.payType == 10) {
//
//        promptStr = @"请选择一种支付方式";
//
//        [TLAlert alertWithInfo:promptStr];
//
//        return ;
//    }

    NSString *payType = @"36";
    
    //获取充值所需信息
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"802710";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];
    http.parameters[@"channelType"] = payType;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        if (self.payType == 1) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
        } else if(self.payType == 0) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - 微信回调
- (void)wxPayWithInfo:(NSDictionary *)info {
    
    
    NSDictionary *dict = info;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"wechatPackage"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]){
        
    } else {
        
        [TLAlert alertWithError:@"充值失败"];
    }
    
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                
                [TLAlert alertWithSucces:@"充值成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                [TLAlert alertWithError:@"充值失败"];
            }
        });
    };
    
}

#pragma mark - 支付宝回调
- (void)aliPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    [TLAlipayManager manager].payCallBack = ^(BOOL isSuccess, NSDictionary *resultDict) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"充值成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [TLAlert alertWithError:@"充值失败"];
        }
    };
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    if (![string isEqualToString:@""]) {
    //
    //        _promptLabel.hidden = YES;
    //
    //    }else {
    //
    //        if (range.location == 0) {
    //
    //            _promptLabel.hidden = NO;
    //        }
    //    }
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        
        //限制小数点前的位数
//        NSInteger count = textField != _freightTF ? 6: 3;
//
//        if (textField.text.length >= count) {  //小数点前面6位
//
//            return NO;
//        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
//        if (textField.text.length >= 12) {
//            return NO;
//        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {
        return NO;  //小数点后面两位
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc && [string isEqualToString:@"."]) {
        return NO;  //控制只有一个小数点
    }
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
