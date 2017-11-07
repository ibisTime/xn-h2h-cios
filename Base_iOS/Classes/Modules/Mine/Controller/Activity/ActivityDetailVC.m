//
//  ActivityDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ActivityDetailVC.h"
#import "DetailWebView.h"
#import "PublishVC.h"
#import "NavigationController.h"
#import "TabbarViewController.h"

@interface ActivityDetailVC ()

@property (nonatomic, strong) DetailWebView *detailWebView;

@end

@implementation ActivityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    self.view.backgroundColor = kWhiteColor;
    
    //详情
    [self initWebView];

}

#pragma mark - Init
- (void)initWebView {
    
    BaseWeakSelf;
    
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 50)];
    
    [self.detailWebView loadWebWithString:_activity.desc];
    
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
    //报名
    UIButton *enrollBtn = [UIButton buttonWithTitle:@"我要报名" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:5];
    
    enrollBtn.frame = CGRectMake(15, 5, kScreenWidth - 2*15, 40);
    
    [enrollBtn addTarget:self action:@selector(clickEnroll:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:enrollBtn];
}

#pragma mark - Events
- (void)clickEnroll:(UIButton *)sender {
    
    BaseWeakSelf;
    
    PublishVC *publishVC = [PublishVC new];
    
    publishVC.activityCode = self.activity.code;
    publishVC.freightType = self.activity.type;
    
    publishVC.publishSuccess = ^{
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        TabbarViewController *tabbarVC = (TabbarViewController *)weakSelf.tabBarController;
        
        tabbarVC.currentIndex = 1;
    };
    
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:publishVC];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
