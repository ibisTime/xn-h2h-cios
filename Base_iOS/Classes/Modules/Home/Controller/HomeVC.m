//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"

#import "TLBannerView.h"
#import "SelectScrollView.h"
#import "MJRefresh.h"

#import "BannerModel.h"
#import "NoticeModel.h"
#import "FilterManager.h"

#import "TLWebVC.h"
#import "HomeGoodListVC.h"
#import "SyetemNoticeVC.h"
#import "RechargeActivityVC.h"
#import "InviteFriendVC.h"
#import "FilterVC.h"
#import "SignInVC.h"
#import "CircleVC.h"

@interface HomeVC ()
//滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;

@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//活动
@property (nonatomic, strong) UIView *activityView;
//头条
@property (nonatomic, strong) UIView *headLineView;

@property (nonatomic, strong) UIButton *headBtn;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;
//圈子
@property (nonatomic, strong) UIButton *circleBtn;
//商品
@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;
//交易圈子图片
@property (nonatomic, copy) NSString *tradeImg;

@end

@implementation HomeVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    //系统消息
    [self requestNoticeList];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kAppCustomMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.shadowImage = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithText:@"首页" textColor:kWhiteColor textFont:18.0];
    
    [self initScrollView];

    //添加下拉刷新
    [self addDownRefresh];
    //签到
    [self initRightItem];
    //轮播图
    [self initBannerView];
    //活动
    [self initActivityView];
    //头条
    [self initHeadLineView];
    //圈子
    [self initCircleView];
    //商品
    [self initSelectScrollView];
    //添加子控制器
    [self addSubViewController];
    //banner图
    [self getBanner];
    //获取圈子图片
    [self requestTradeImg];
    //添加通知
    [self addNotification];
}

#pragma mark - Init

- (void)addDownRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(clickRefresh)];
    
    self.scrollView.mj_header = header;
    
}

- (void)initRightItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"签到" titleColor:kWhiteColor frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(clickSign)];
    
}

- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - kTabBarHeight)];
    
    self.scrollView.backgroundColor = kBackgroundColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    
    [self.view addSubview:self.scrollView];
}

- (void)initBannerView {
    
    BaseWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        TLWebVC *webVC = [TLWebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    [self.scrollView addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initActivityView {
    
    self.activityView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 87)];
    
    self.activityView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:self.activityView];
    
    NSArray *imgArr = @[@"优惠活动",@"充值送",@"邀请好友"];
    
    NSArray *textArr = @[@"优惠活动",@"充值送",@"邀请好友"];
    
    for (int i = 0; i < imgArr.count; i++) {
        
        CGFloat btnWidth = kScreenWidth/3.0;
        
        CGFloat btnHeight = 87;
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[i] titleColor:kTextColor3 backgroundColor:kClearColor titleFont:12.0];
        
        btn.frame = CGRectMake(i%3*btnWidth, i/3*btnHeight, btnWidth, btnHeight);
        
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        
        btn.tag = 1100 + i;
        
        [btn addTarget:self action:@selector(clickActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self.activityView addSubview:btn];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(48, -btn.imageView.width, 0, 0)];
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, -btn.titleLabel.width)];
    }
    
}

- (void)initHeadLineView {
    
    self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.activityView.yy, kScreenWidth, 50)];
    
    self.headLineView.backgroundColor = kWhiteColor;
    //背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 2*15, 50)];
    
    bgView.backgroundColor = kWhiteColor;
    
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    
    [self.headLineView addSubview:bgView];
    //icon
    UIImageView *iconIV= [[UIImageView alloc] initWithImage:kImage(@"我淘头条")];
    
    iconIV.frame = CGRectMake(10, 10, 30, 28);
    
    [bgView addSubview:iconIV];
    
    //内容
    UIButton *contentBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    contentBtn.frame = CGRectMake(iconIV.xx + 15, 0, bgView.width - iconIV.xx - 15 - 10, 50);
    
    [contentBtn setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [contentBtn addTarget:self action:@selector(clickSystemNotice) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:contentBtn];
    
    self.headBtn = contentBtn;
    
    [self.scrollView addSubview:self.headLineView];
}

- (void)initCircleView {
    
    [self.scrollView layoutSubviews];
    
    self.circleBtn = [UIButton buttonWithImageName:@""];

    self.circleBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;

    self.circleBtn.backgroundColor = kWhiteColor;
    
    self.circleBtn.frame = CGRectMake(0, self.headLineView.yy, kScreenWidth, kWidth(90));
    
    [self.circleBtn addTarget:self action:@selector(clickLookCircle:) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollView addSubview:self.circleBtn];
//    [self.circleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@0);
//        make.top.equalTo(self.headLineView.mas_bottom);
//
//    }];
    
//    UIImageView *iconIV= [[UIImageView alloc] initWithImage:kImage(@"交易圈子")];
//
//    iconIV.frame = CGRectMake(5, 0, kScreenWidth - 10, kWidth(90));
    
//    [self.circleBtn addSubview:iconIV];

}

- (void)initSelectScrollView {
    
    self.titles = @[@"热门推荐", @"附近商品"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, self.circleBtn.yy + 10, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    self.selectScrollView.selectBlock = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshScrollViewData" object:nil];

    };
    
    [self.scrollView addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        HomeGoodListVC *childVC = [[HomeGoodListVC alloc] init];
        
        childVC.status = i;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
        //        [childVC startLoadData];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.selectScrollView.yy);
    
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDidFinish) name:@"RefreshDidFinish" object:nil];
}

#pragma mark - Events
- (void)clickSign {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        loginVC.loginSuccess = ^(){
            
            [weakSelf clickSign];
        };
        
        [self presentViewController:nav animated:YES completion:nil];

        return;
    }
    
    SignInVC *signInVC = [SignInVC new];
    
    signInVC.title = @"每日签到";
    
    [self.navigationController pushViewController:signInVC animated:YES];
}

- (void)clickActivity:(UIButton *)sender {
    
    BaseWeakSelf;
    
    NSInteger index = sender.tag - 1100;
    
    switch (index) {
        case 0:
        {
            [FilterManager manager].isCoupon = YES;
            
            FilterVC *filterVC = [[FilterVC alloc] init];
            
            filterVC.type = FilterVCTypeCouponGood;
            
            filterVC.returnBlock = ^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self.navigationController pushViewController:filterVC animated:YES];
        }break;
            
        case 1:
        {
            RechargeActivityVC *activityVC = [RechargeActivityVC new];
            
            [self.navigationController pushViewController:activityVC animated:YES];
            
        }break;
            
        case 2:
        {
            InviteFriendVC *friendVC = [InviteFriendVC new];
            
            [self.navigationController pushViewController:friendVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

- (void)clickSystemNotice {
    
    SyetemNoticeVC *noticeVC = [SyetemNoticeVC new];
    
    [self.navigationController pushViewController:noticeVC animated:YES];
}

- (void)clickLookCircle:(UIButton *)sender {
    
    CircleVC *circleVC = [CircleVC new];
    
    circleVC.title = @"交易圈子";
    
    [self.navigationController pushViewController:circleVC animated:YES];
}

- (void)clickRefresh {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshGoodData" object:nil];
    
}

- (void)refreshDidFinish {
    
    [self.scrollView.mj_header endRefreshing];

}

#pragma mark - Data
- (void)getBanner {
    
    //广告图
    __weak typeof(self) weakSelf = self;
    TLNetworking *http = [TLNetworking new];
    http.code = @"805806";
    http.parameters[@"type"] = @"2";
    http.parameters[@"belong"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestNoticeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [helper modelClass:[NoticeModel class]];
    
    //消息数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        weakSelf.notices = objs;
        
        if (weakSelf.notices.count > 0) {
            
            NoticeModel *notice = weakSelf.notices[0];
            
            [self.headBtn setTitle:notice.smsTitle forState:UIControlStateNormal];

        } else {
            
            [self.headBtn setTitle:@"无" forState:UIControlStateNormal];

        }
        
        [self.headBtn setTitleLeft];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestTradeImg {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808917";
    http.parameters[@"key"] = @"tradeImg";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.tradeImg = responseObject[@"data"][@"cvalue"];
        
        [self.circleBtn sd_setImageWithURL:[NSURL URLWithString:[self.tradeImg convertImageUrl]] forState:UIControlStateNormal];
        
        [self.circleBtn sd_setImageWithURL:[NSURL URLWithString:[self.tradeImg convertImageUrl]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            CGFloat fixelW = CGImageGetWidth(image.CGImage);
//            CGFloat fixelH = CGImageGetHeight(image.CGImage);
//
//            //通过图片的宽高比得到视图展示的高度
//            CGFloat height = fixelH*kScreenWidth/fixelW;
//
//            self.circleBtn.height = height;
//
//            self.selectScrollView.y = self.circleBtn.yy + 10;
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
