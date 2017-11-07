//
//  RechargeActivityVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "RechargeActivityVC.h"

#import "RechargeActivityModel.h"
#import "CurrencyModel.h"

#import "DetailWebView.h"
#import "RechargeVC.h"

@interface RechargeActivityVC ()

@property (nonatomic, strong) DetailWebView *detailWebView;

@property (nonatomic, copy) NSString *rechargeDesc;

@property (nonatomic, strong) NSMutableArray <RechargeActivityModel *>*rechargeArr;
//账户
@property (nonatomic, copy) NSString *accountNumber;


@end

@implementation RechargeActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    //获取活动详情
    [self requestRecharge];

}

#pragma mark - Init
- (void)initWebView {
    
    BaseWeakSelf;
    
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 50)];
    
    if (self.rechargeArr.count > 0) {
        
        RechargeActivityModel *model = self.rechargeArr[0];

        [self.detailWebView loadWebWithString:model.desc];
    }
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
//        weakSelf.detailWebView.height = height;
        
        weakSelf.detailWebView.webView.scrollView.height = height;
        //报名
        [weakSelf initBottomView];
    };
    
    [self.view addSubview:self.detailWebView];
}

- (void)initBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailWebView.yy, kScreenWidth, 50 + kBottomInsetHeight)];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bottomView];
    //充值
    UIButton *rechargeBtn = [UIButton buttonWithTitle:@"我要充值" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:5];
    
    rechargeBtn.frame = CGRectMake(15, 5, kScreenWidth - 2*15, 40);
    
    [rechargeBtn addTarget:self action:@selector(clickRecharge) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:rechargeBtn];
}

#pragma mark - Events
- (void)clickRecharge {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf clickRecharge];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    RechargeVC *rechargeVC = [RechargeVC new];
        
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}

- (void)requestRecharge {
    
    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.code = @"801050";
    
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"1";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"type"] = @"4";
    
    [helper modelClass:[RechargeActivityModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.rechargeArr = objs;
        //详情
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
