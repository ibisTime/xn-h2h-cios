//
//  NoticeDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/4.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeDetailVC.h"
#import "DetailWebView.h"

@interface NoticeDetailVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) DetailWebView *webview;

@end

@implementation NoticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息详情";
    
    [self initScrollView];
    
    [self initTopView];
    
    [self initWebView];
}

#pragma mark - Init
- (void)initTopView {
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,40)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.topView];
    
    UILabel *titleLabel = [UILabel labelWithText:self.notice.smsTitle textColor:[UIColor textColor] textFont:15.0];
    
    [self.topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        
    }];
    
    CGFloat lineH = 1;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - lineH, kScreenWidth, lineH)];
    
    line.backgroundColor = kPaleGreyColor;
    
    [self.topView addSubview:line];
    
}

- (void)initWebView {
    
    BaseWeakSelf;
    
    self.webview = [[DetailWebView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth, kScreenHeight - 40 - kNavigationBarHeight - kBottomInsetHeight)];
    
    self.webview.webViewBlock = ^(CGFloat height) {
        
        weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, 40 + height);
        
        //        weakSelf.webview.height = height;
    };
    
    [self.scrollView addSubview:self.webview];
    
    [self.webview loadWebWithString:self.notice.smsContent];
}

- (void)initScrollView {
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.scrollView.backgroundColor = kWhiteColor;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
