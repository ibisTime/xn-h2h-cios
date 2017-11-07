//
//  InviteFriendVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "InviteFriendVC.h"
#import "ShareView.h"

#import "RechargeActivityModel.h"

#import "HistoryInviteVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface InviteFriendVC ()

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) UILabel *activityRuleLbl;     //活动规则
//
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation InviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    
    [UIBarButtonItem addRightItemWithTitle:@"推荐历史" titleColor:kTextColor frame:CGRectMake(0, 0, 70, 30) vc:self action:@selector(historyFriends)];
    
    //scrollview
    [self initScrollView];
    
    [self initSubviews];
    
    [self requestActivityRule];
    
    [self getUrl];
}

#pragma mark - Init
- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
    
}

- (void)initSubviews {

    UIImageView *inviteIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    inviteIV.image = kImage(@"背景");
    
    [self.scrollView addSubview:inviteIV];
    
    UIButton *recommendBtn = [UIButton buttonWithTitle:@"点击邀请好友" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:kWidth(18) cornerRadius:24];
    
    recommendBtn.layer.borderWidth = 1.5;
    recommendBtn.layer.borderColor = [UIColor colorWithHexString:@"#383737"].CGColor;
    
    [recommendBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    
    recommendBtn.frame = CGRectMake(40, kHeight(315), kScreenWidth - 80, 48);
    
    [self.scrollView addSubview:recommendBtn];
    
    [self.scrollView addSubview:self.centerView];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"活动规则")];
    
    iconIV.frame = CGRectMake(0, recommendBtn.yy + kHeight(36), 105, 12);
    
    iconIV.centerX = self.view.centerX;
    
    [self.scrollView addSubview:iconIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"活动规则" textColor:kTextColor textFont:kWidth(15)];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    textLbl.frame = CGRectMake(0, recommendBtn.yy + kHeight(35), 100, kWidth(15));
    
    textLbl.centerX = self.view.centerX;

    [self.scrollView addSubview:textLbl];
    
    CGFloat leftMargin = 15;
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, textLbl.yy + kHeight(24), kScreenWidth, 100)];
    
    blueView.tag = 2200;
    
    blueView.backgroundColor = kAppCustomMainColor;
    
    [self.scrollView addSubview:blueView];
    
    //活动规则
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, kScreenWidth - 2*leftMargin, 100)];
    
    bgView.tag = 1200;
    
    bgView.layer.borderWidth = 1;
    
    bgView.layer.borderColor = kTextColor3.CGColor;
    
    bgView.backgroundColor = [UIColor colorWithHexString:@"#fdfbed"];
    
    [blueView addSubview:bgView];
    
    UILabel *promptLbl = [UILabel labelWithText:@"" textColor:[UIColor zh_themeColor] textFont:13.0];
    
    promptLbl.backgroundColor = kClearColor;
    
    promptLbl.numberOfLines = 0;
    
    promptLbl.frame = CGRectMake(leftMargin + 3, 10, bgView.width - 2*leftMargin, 70);
    
    [bgView addSubview:promptLbl];
    
    self.activityRuleLbl = promptLbl;
    
}

- (void)setRemark:(NSString *)remark {
    
    _remark = remark;
    
    //注意事项
    //
    CGFloat height = ([_remark componentsSeparatedByString:@"\n"].count+1)*25;

    [self.activityRuleLbl labelWithTextString:_remark lineSpace:10];
    
    self.activityRuleLbl.height = height;
    
    UIView *blueView = [self.scrollView viewWithTag:2200];
    
    blueView.height = height + 40;
    
    UIView *bgView = [blueView viewWithTag:1200];
    
    bgView.height = height + 20;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, blueView.yy);

}

#pragma mark - Events
- (void)historyFriends {

    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf historyFriends];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    HistoryInviteVC *inviteVC = [HistoryInviteVC new];
    
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)inviteFriend {

    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf inviteFriend];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
        
    }];
    
    shareView.shareTitle = @"邀请好友";
    shareView.shareDesc = @"邀好友送优惠券 多邀多得";
    shareView.shareURL = [NSString stringWithFormat:@"http://cm.tour.hichengdai.com/?#/home/recommend?userReferee=%@", [TLUser user].userId];
    
    [self.view addSubview:shareView];
}

#pragma mark - Data
- (void)requestActivityRule {

    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.code = @"801050";
    
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"1";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"type"] = @"3";
    
    [helper modelClass:[RechargeActivityModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        if (objs.count > 0) {
            
            RechargeActivityModel *model = objs[0];
            
            self.remark = model.desc;

        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUrl {
    
    NSString *shareStr = [NSString stringWithFormat:@"%@%@", [AppConfig config].shareBaseUrl, [TLUser user].userId];

    self.shareUrl = shareStr;
    
//    TLNetworking *http = [TLNetworking new];
//
//    http.code = @"805917";
//    http.parameters[@"ckey"] = @"domainUrl";
//
//    [http postWithSuccess:^(id responseObject) {
//
//        NSString *url = responseObject[@"data"][@"cvalue"];
//
//        NSString *shareStr = [NSString stringWithFormat:@"%@?kind=C&mobile=%@", url, [TLUser user].mobile];
//        //
//        self.shareUrl = shareStr;
//
//    } failure:^(NSError *error) {
//
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
