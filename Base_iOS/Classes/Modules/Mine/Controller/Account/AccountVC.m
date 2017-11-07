//
//  AccountVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AccountVC.h"
#import "AccountView.h"

#import "CurrencyModel.h"
#import "AccountInfoModel.h"

#import "RechargeVC.h"
#import "WithdrawalsVC.h"
#import "RMBFlowListVC.h"

@interface AccountVC ()<AccountDelegate>

@property (nonatomic, strong) AccountView *accountView;

@property (nonatomic, strong) NSNumber *balance;

@property (nonatomic, strong) AccountInfoModel *accountModel;

@end

@implementation AccountVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //获取余额
    [self requestUserInfo];
    //人民币账户统计
    [self requestAccountInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的账户"];
    
    [self initHeaderView];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    
    self.accountView.delegate = self;
    
    [self.view addSubview:self.accountView];
    
}

#pragma mark - AccountDelegate

- (void)didSelectedWithType:(AccountType)type idx:(NSInteger)idx {
    
    switch (type) {
        case AccountTypeRecharge:
        {
            RechargeVC *rechargeVC = [RechargeVC new];
            
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }break;
            
        case AccountTypeWithdrawals:
        {
            WithdrawalsVC *withdrawalsVC = [WithdrawalsVC new];

            withdrawalsVC.balance = self.balance;

            withdrawalsVC.accountNum = self.accountNumber;

            [self.navigationController pushViewController:withdrawalsVC animated:YES];
            
        }break;
            
        case AccountTypeRMBFlow:
        {
            RMBFlowListVC *flowVC = [RMBFlowListVC new];
            
            flowVC.accountNumber = self.accountNumber;
            
            [self.navigationController pushViewController:flowVC animated:YES];
            
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Data

- (void)requestUserInfo {
    
    BaseWeakSelf;
    //刷新rmb和积分
    TLNetworking *sjHttp = [TLNetworking new];
    sjHttp.code = @"802503";
    sjHttp.parameters[@"userId"] = [TLUser user].userId;
    
    if (![TLUser user].token) {
        
        return;
    }
    
    sjHttp.parameters[@"token"] = [TLUser user].token;
    
    [sjHttp postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"CNY"]) {
                
                weakSelf.balance = obj.amount;
                
                weakSelf.accountView.rmbText = [obj.amount convertToRealMoney];
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestAccountInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802903";
    http.showView = self.view;
    http.parameters[@"accountNumber"] = self.accountNumber;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.accountModel = [AccountInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.accountView.accountModel = self.accountModel;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
