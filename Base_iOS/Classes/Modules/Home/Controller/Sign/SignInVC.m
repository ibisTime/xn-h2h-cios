//
//  SignInVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SignInVC.h"

#import "MyCalendarItem.h"
#import "CurrencyModel.h"
#import "SignDateModel.h"

#import "HTMLStrVC.h"

#import "LDCalendarView.h"
#import "NSDate+extend.h"

@interface SignInVC ()

@property (nonatomic, strong) UIView *topView;
//签到按钮
@property (nonatomic, strong) UIButton *signBtn;
//签到提示
@property (nonatomic, strong) UILabel *signPromptLbl;
//积分总额
@property (nonatomic, strong) UILabel *amountLbl;
//日历
@property (nonatomic, strong) LDCalendarView *calendarView;
//签到状态
@property (nonatomic, copy) NSString *isSign;
//签到日期
@property (nonatomic, strong) NSMutableArray <SignDateModel *>*dateModels;

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.dateModels = [NSMutableArray array];
    
    //签到规则
    [self initSignRule];
    //顶部
    [self initTopView];
    //日历
    [self initCalenderView];
    //判断是否已签到
    [self checkSignStatus];
    
}

#pragma mark - Init

- (LDCalendarView *)calendarView {
    
    if (!_calendarView) {
        
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        
        [self.view addSubview:_calendarView];
        
        [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(@0);
            make.top.equalTo(self.topView.mas_bottom);
            
        }];
    }
    return _calendarView;
}

- (void)initSignRule {
    
    UIButton *ruleBtn = [UIButton buttonWithTitle:@"签到规则" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    ruleBtn.frame = CGRectMake(0, 0, 80, 44);
    
    [ruleBtn addTarget:self action:@selector(readSignRule) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:ruleBtn.bounds];
    
    [customView addSubview:ruleBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
}

- (void)initTopView {
    
    self.topView = [[UIView alloc] init];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@212.5);
        
    }];
    
    //背景
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:kImage(@"签到背景")];
    
    [self.topView addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(@0);
        
    }];
    //透明度
    UIView *alphaView = [[UIView alloc] init];
    
    alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.16];
    
    alphaView.layer.cornerRadius = 60;
    alphaView.clipsToBounds = YES;
    
    [self.topView addSubview:alphaView];
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.width.height.equalTo(@120);
        
    }];
    
    //签到按钮
    self.signBtn = [[UIButton alloc] init];
    
    self.signBtn.backgroundColor = kWhiteColor;
    
    self.signBtn.layer.cornerRadius = 49;
    self.signBtn.clipsToBounds = YES;
    
    [alphaView addSubview:self.signBtn];
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(11, 11, 11, 11));
        
    }];
    //签到积分
    self.amountLbl = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:18.0];
    
    self.amountLbl.textAlignment = NSTextAlignmentCenter;
    
    [alphaView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(alphaView.mas_centerX);
        make.centerY.equalTo(alphaView.mas_centerY);
        make.height.equalTo(@(kFontHeight(18)));
        
    }];
    //签到提示
    self.signPromptLbl = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:14.0];
    
    self.signPromptLbl.textAlignment = NSTextAlignmentCenter;
    
    [alphaView addSubview:self.signPromptLbl];
    [self.signPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(alphaView.mas_centerX);
        make.bottom.equalTo(self.amountLbl.mas_top).offset(-5);
        
    }];
    
    //已获积分
    UILabel *textLbl = [UILabel labelWithText:@"已获积分" textColor:kAppCustomMainColor textFont:11.0];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [alphaView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(self.amountLbl.mas_bottom).offset(4);
        
    }];
}

- (void)initCalenderView {
    
    [self.calendarView show];
}

#pragma mark - Events
- (void)readSignRule {
    
    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeSignRule;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

#pragma mark - Data

- (void)checkSignStatus {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"805148";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.isSign = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"todaySign"]];
        
        if ([self.isSign isEqualToString:@"0"]) {
            //签到
            [self sign];
            
        } else {
            
            self.signPromptLbl.text = @"签到成功";
            
            //获取签到积分
            [self requestSignIntegral];
            //获取已签到日期
            [self signedDate];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)sign {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"805140";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"errorCode"] isEqualToString:@"0"]) {
            
            [TLAlert alertWithSucces:@"签到成功"];
            
            self.signPromptLbl.text = @"签到成功";
            
        } else {
            
            self.signPromptLbl.text = @"签到失败";
        }
        
        //获取签到积分
        [self requestSignIntegral];
        //获取已签到日期
        [self signedDate];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestSignIntegral {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802900";
    http.parameters[@"accountNumber"] = [TLUser user].jfAccountNumber;
    http.parameters[@"bizType"] = @"02";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSNumber *totalAmount = responseObject[@"data"][@"totalAmount"];
        
        self.amountLbl.text = [totalAmount convertToSimpleRealMoney];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)signedDate {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805145";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.start = 1;
    helper.limit = 40;
    
    [helper modelClass:[SignDateModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.dateModels = objs;
        
        NSMutableArray *dateArr = [NSMutableArray array];
        
        [self.dateModels enumerateObjectsUsingBlock:^(SignDateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSString *date = [obj.signDatetime convertDateWithFormat:@"d"];
            
            [dateArr addObject:date];
        }];
        
        //处理数据
        self.calendarView.dateArr = dateArr.copy;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
