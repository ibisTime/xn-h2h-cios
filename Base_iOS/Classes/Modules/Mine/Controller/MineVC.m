//
//  MineVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"

#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"

#import "CurrencyModel.h"
#import "NSAttributedString+add.h"
#import "OrderNumberModel.h"

//#import "UserDetailVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "SettingVC.h"
#import "AccountVC.h"
#import "JFFlowLIstVC.h"
#import "UserDetailEditVC.h"
#import "OrderVC.h"
#import "HomePageVC.h"
#import "FollowAndFansVC.h"

#import "MyPublishVC.h"
#import "MySellListVC.h"
#import "MyWantListVC.h"
#import "MyFootprintListVC.h"
#import "CouponVC.h"
#import "ActivityVC.h"

@interface MineVC ()<MineHeaderSeletedDelegate>
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//订单
@property (nonatomic, strong) UIView *orderView;
//我的
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) TLImagePicker *imagePicker;
//rmb
@property (nonatomic, copy) NSString *accountNumber;
//jf
@property (nonatomic, copy) NSString *jfAccountNum;

@property (nonatomic, strong) UIScrollView *scrollView;
//订单状态数量
@property (nonatomic, strong) NSMutableArray *orderNumArr;

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([TLUser user].userId) {
        //获取用户信息
        [self requestUserInfo];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
 
    //修改NavigationBar颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //修改状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //通知
    [self addNotification];
    //scrollView
    [self initScrollView];
    //顶部视图
    [self initMineHeaderView];
    //订单
    [self initOrderView];
    //底部模块
    [self initBottomView];
    //获取订单数量
    [self getOrderNum];
}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - Init
- (void)initScrollView {
    
    //    [self setStatusBarBackgroundColor:kAppCustomMainColor];
    
    self.view.backgroundColor = RGB(81, 181, 253);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight - kBottomInsetHeight)];
    
    self.scrollView.backgroundColor = kBackgroundColor;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.scrollView];
}

- (void)initMineHeaderView {
    
    MineHeaderView *mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + kNavigationBarHeight)];
    
    mineHeaderView.delegate = self;
    
    [self.scrollView addSubview:mineHeaderView];
    
    self.headerView = mineHeaderView;
}

- (void)initOrderView {
    
    self.orderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.yy + 10, kScreenWidth, 136)];
    
    self.orderView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.orderView];
    
    UILabel *orderLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 100, 45) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(15.0) textColor:kTextColor];
    
    orderLbl.text = @"我的订单";
    
    [self.orderView addSubview:orderLbl];
    
    UIButton *allOrderBtn = [UIButton buttonWithTitle:@"查看更多" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:12.0];
    
    allOrderBtn.frame = CGRectMake(kScreenWidth - 100 - 15, 0, 100, 45);
    
    [allOrderBtn setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
    
    [allOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -allOrderBtn.imageView.width + 15, 0, 0)];
    
    [allOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -allOrderBtn.titleLabel.width - allOrderBtn.width + allOrderBtn.imageView.width)];
    
    [allOrderBtn addTarget:self action:@selector(clickAllOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.orderView addSubview:allOrderBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 1)];
    
    line.backgroundColor = kLineColor;
    [self.orderView addSubview:line];
    
    self.orderNumArr = [NSMutableArray array];

    NSArray *imgArr = @[@"待付款",@"待发货",@"待收货",@"已收货", @"已评价"];
    NSArray *textArr = @[@"待付款",@"待发货",@"待收货",@"已收货", @"已评价"];
    
    for (int i = 0; i < imgArr.count; i++) {
        
        CGFloat btnWidth = kScreenWidth/(1.0*imgArr.count);
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[i] titleColor:kTextColor3 backgroundColor:kClearColor titleFont:12.0];
        
        btn.frame = CGRectMake(i*btnWidth, line.yy, btnWidth, 90);
        
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        
        btn.tag = 1100 + i;
        
        [btn addTarget:self action:@selector(clickLookOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderView addSubview:btn];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(48, -btn.imageView.width, 0, 0)];
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, -btn.titleLabel.width)];
        
        UILabel *orderNumLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:12.0];
        
        orderNumLbl.layer.cornerRadius = 9;
        orderNumLbl.clipsToBounds = YES;
        orderNumLbl.textAlignment = NSTextAlignmentCenter;
        
        orderNumLbl.backgroundColor = kThemeColor;
        
        orderNumLbl.tag = 1600 + i;
        
        orderNumLbl.hidden = YES;
        
        [btn addSubview:orderNumLbl];
        [orderNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX).offset(13);
            make.centerY.equalTo(btn.mas_centerY).offset(-18);
            make.height.equalTo(@18);
            make.width.greaterThanOrEqualTo(@18);
            
        }];
        
        [self.orderNumArr addObject:orderNumLbl];
    }
    
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.orderView.yy + 10, kScreenWidth, kScreenWidth/3.0*2)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.bottomView];
    
    NSArray *imgArr = @[@"我发布的",@"我卖出的",@"活动报名",@"我想要的", @"我的足迹", @"coupon"];
    
    NSArray *textArr = @[@"我发布的",@"我卖出的",@"活动报名",@"我想要的", @"我的足迹", @"优惠券"];
    
    for (int i = 0; i < imgArr.count; i++) {
        
        CGFloat btnWidth = kScreenWidth/3.0;
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[i] titleColor:kTextColor3 backgroundColor:kClearColor titleFont:12.0];
        
        btn.frame = CGRectMake(i%3*btnWidth, i/3*btnWidth, btnWidth, btnWidth);
        
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        
        btn.tag = 1100 + i;
        
        [btn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
        
        //        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(i/3*btnWidth);
        //            make.left.mas_equalTo(i%3*btnWidth);
        //            make.width.mas_equalTo(btnWidth);
        //            make.height.mas_equalTo(btnWidth);
        //        }];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(48, -btn.imageView.width, 0, 0)];
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, -btn.titleLabel.width)];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake((i%3 + 1)*btnWidth, i/3*btnWidth, 1, btnWidth)];
        
        rightLine.backgroundColor = kLineColor;
        
        [self.bottomView addSubview:rightLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(i%3*btnWidth, i/3*btnWidth, btnWidth, 1)];
        
        bottomLine.backgroundColor = kLineColor;
        
        [self.bottomView addSubview:bottomLine];
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.bottomView.yy + 32);
}

#pragma mark - Notification

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderNumber) name:@"RefreshOrderList" object:nil];

}

#pragma mark - Events

- (void)clickAllOrder:(UIButton *)sender {
    
    OrderVC *orderVC = [OrderVC new];
    
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)clickLookOrder:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1100;
    
    OrderVC *orderVC = [OrderVC new];
    
    orderVC.currentIndex = index + 1;
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

- (void)clickBottomBtn:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1100;
    
    switch (index) {
        case 0:
        {
            MyPublishVC *publishVC = [MyPublishVC new];
            
            publishVC.title = @"我发布的";
            
            [self.navigationController pushViewController:publishVC animated:YES];
            
        }break;
            
        case 1:
        {
            MySellListVC *sellListVC = [MySellListVC new];
            
            sellListVC.title = @"我卖出的";
            [self.navigationController pushViewController:sellListVC animated:YES];
            
        }break;
            
        case 2:
        {

            ActivityVC *activityVC = [ActivityVC new];
            
            activityVC.title = @"活动中心";
            
            [self.navigationController pushViewController:activityVC  animated:YES];
            
        }break;
            
        case 3:
        {
            MyWantListVC *wantListVC = [MyWantListVC new];
            
            wantListVC.title = @"我想要的";
            [self.navigationController pushViewController:wantListVC animated:YES];
            
        }break;
            
        case 4:
        {
            
            MyFootprintListVC *footprintVC = [MyFootprintListVC new];
            
            footprintVC.title = @"我的足迹";
            
            [self.navigationController pushViewController:footprintVC animated:YES];
            
        }break;
            
        case 5:
        {
            CouponVC *couponVC = [CouponVC new];
            
            couponVC.title = @"优惠券";
            
            [self.navigationController pushViewController:couponVC animated:YES];
            
        }break;
            
        default:
            break;
    };
}
#pragma mark - Data

- (void)requestUserInfo {
    
    BaseWeakSelf;
    
    if (![TLUser user].token) {
        
        return;
    }
    //    1.刷新用户信息
    [[TLUser user] updateUserInfo];
    
    //    2.刷新rmb和积分
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"JF"]) {
                
                weakSelf.headerView.jfNum = [obj.amount convertToRealMoney];
                
                weakSelf.jfAccountNum = obj.accountNumber;
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                weakSelf.headerView.rmbNum = [obj.amount convertToRealMoney];
                
                [[NSUserDefaults standardUserDefaults] setObject:[obj.amount convertToRealMoney] forKey:@"BalanceMoney"];
                
                weakSelf.accountNumber = obj.accountNumber;
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getOrderNum {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808063";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        OrderNumberModel *numModel = [OrderNumberModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.orderNumArr enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            switch (idx) {
                case 0:
                    {
                        NSString *num = numModel.toPayCount > 99 ? @" 99+  ": [NSString stringWithFormat:@"%ld", numModel.toPayCount];
                        
                        obj.text = num;
                        
                        obj.hidden = numModel.toPayCount == 0;

                        
                    }
                    break;
                    
                case 1:
                {
                    NSString *num = numModel.payCount > 99 ? @" 99+  ": [NSString stringWithFormat:@"%ld", numModel.payCount];
                    
                    obj.text = num;
                    
                    obj.hidden = numModel.payCount == 0;
                    
                    
                }
                    break;
                    
                case 2:
                {
                    NSString *num = numModel.sendCount > 99 ? @" 99+  ": [NSString stringWithFormat:@"%ld", numModel.sendCount];
                    
                    obj.text = num;
                    
                    obj.hidden = numModel.sendCount == 0;
                    
                    
                }
                    break;
                    
                case 3:
                {
                    NSString *num = numModel.receiveCount > 99 ? @" 99+  ": [NSString stringWithFormat:@"%ld", numModel.receiveCount];
                    
                    obj.text = num;
                    
                    obj.hidden = numModel.receiveCount == 0;
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - 通知处理
- (void)loginOut {
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:nil placeholderImage:USER_PLACEHOLDER_SMALL];
    //
    [self.headerView reset];
    //
    self.headerView.nameLbl.text = @"--";
    
    [[TLUser user] loginOut];
    
}


- (void)changeInfo {
    
    NSString *userPhotoStr = [[TLUser user].photo convertImageUrl];
    
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.headerView.nameLbl.text = [TLUser user].nickname;
    
    self.headerView.foucsNum = [[TLUser user].totalFollowNum stringValue];
    
    self.headerView.fansNum = [[TLUser user].totalFansNum stringValue];
}

- (void)refreshOrderNumber {
    //获取各订单状态数量
    [self getOrderNum];
}

#pragma mark- 修改头像
- (void)choosePhoto {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = IMG_UPLOAD_CODE;
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {
                
                [TLProgressHUD showWithStatus:@""];
                
                QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone2];
                    
                }]];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    //                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    //设置头像
                    
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = USER_CHANGE_USER_PHOTO;
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"修改头像成功"];
                        [TLUser user].photo = key;
                        weakSelf.headerView.userPhoto.image = image;
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}

#pragma mark - MineHeaderSeletedDelegate

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {
    
    switch (type) {
        case MineHeaderSeletedTypeDefault:
        {
            
        }
            break;
            
        case MineHeaderSeletedTypeSetting:
        {
            SettingVC *settingVC = [SettingVC new];
            
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }break;
            
        case MineHeaderSeletedTypeSelectPhoto:
        {
//            [self choosePhoto];
            HomePageVC *pageVC = [HomePageVC new];
            
            pageVC.userId = [TLUser user].userId;
            
            [self.navigationController pushViewController:pageVC animated:YES];
            
        }break;
            
        case MineHeaderSeletedTypeIntregalFlow:
        {
            JFFlowLIstVC *flowVC = [JFFlowLIstVC new];
            
            flowVC.accountNumber = self.jfAccountNum;
            
            [self.navigationController pushViewController:flowVC animated:YES];
            
        }break;
            
        case MineHeaderSeletedTypeAccount:
        {
            
            AccountVC *accountVC = [AccountVC new];
            
            accountVC.accountNumber = self.accountNumber;
            
            [self.navigationController pushViewController:accountVC animated:YES];
        }break;
            
        case MineHeaderSeletedTypeFoucsAndFans:
        {
            FollowAndFansVC *followVC = [FollowAndFansVC new];
            
            followVC.type = idx;
            
            followVC.title = @"关注和粉丝";
            
            [self.navigationController pushViewController:followVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

