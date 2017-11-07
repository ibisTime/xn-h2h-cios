//
//  HomePageVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageCollectionView.h"

#import "GoodDetailVC.h"
#import "UserDetailEditVC.h"

@interface HomePageVC ()

@property (nonatomic, strong) TLUser *currentUser;

@property (nonatomic, strong) HomePageCollectionView *collectionView;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;
//是否已关注
@property (nonatomic, assign) BOOL isFollow;

@end

@implementation HomePageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取用户信息
    [self getUserInfo];
    //
    [self addNotification];

}

#pragma mark - Init

- (void)initReturnButton {
    
    UIButton *returnBtn = [UIButton buttonWithImageName:@"返回-白色"];
    
    returnBtn.frame = CGRectMake(10, 20, 40, 44);
    
    [returnBtn addTarget:self action:@selector(clickReturn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:returnBtn];
}

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = (kScreenWidth - 10)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 98);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[HomePageCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight + kNavigationBarHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.homePageBlock = ^(NSIndexPath *indexPath) {
        
        GoodModel *good = weakSelf.goods[indexPath.row];
        
        GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
        
        detailVC.code = good.code;
        
        detailVC.userId = weakSelf.userId;
                
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
}

#pragma mark - Events
- (void)clickReturn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerViewEventsWithType:(HomePageType)type {
    
    switch (type) {
        case HomePageTypeEdit:
        {
            UserDetailEditVC *detailVC = [UserDetailEditVC new];
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
            
        case HomePageTypeFollow:
        {
            BaseWeakSelf;
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                loginVC.loginSuccess = ^{
                    
                    [weakSelf followUser];
                };
                
                NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            //点击关注
            [self followUser];
            
        }break;
            
        case HomePageTypeCancelFollow:
        {
            [self cancelFollowUser];
            
        }break;
            
        case HomePageTypeChat:
        {
            [self chat];
            
        }break;
            
        default:
            break;
    }
}

- (void)changeInfo {
    
    NSString *userPhotoStr = [[TLUser user].photo convertImageUrl];
    
    //
    [self.collectionView.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.collectionView.headerView.nameLbl.text = [TLUser user].nickname;
    
}

- (void)chat {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf chat];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    IMAUser *user = [[IMAUser alloc] initWith:self.userId];
    
    user.nickName = self.currentUser.nickname;
    user.icon = [self.currentUser.photo convertImageUrl];
    user.remark = self.currentUser.nickname;
    user.userId = self.userId;
    
    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    
    userInfo.minePhoto = [TLUser user].photo;
    userInfo.friendPhoto = self.currentUser.photo;
    userInfo.friendNickName = self.currentUser.nickname;
    
    ChatViewController *chatVC = [[CustomChatUIViewController alloc] initWith:user];
    
    chatVC.userInfo = userInfo;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)followUser {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805110";
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"关注成功"];
        
        self.collectionView.headerView.followBtn.selected = YES;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelFollowUser {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"取消成功"];
        
        self.collectionView.headerView.followBtn.selected = NO;
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data

- (void)getUserInfo {
    
    //1.根据userId 获取用户信息
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = @"805256";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.currentUser = [TLUser mj_objectWithKeyValues:responseObject[@"data"]];

        //collectionView
        [self initCollectionView];
        //返回按钮
        [self initReturnButton];
        //获取商品列表
        [self requestGoodList];

    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808021";
    
//    helper.parameters[@"statusList"] = @[@"3"];

//    helper.parameters[@"statusList"] = @[@"4", @"5", @"6"];
    
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"userId"] = self.userId;
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    
    [helper modelClass:[GoodModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        weakSelf.collectionView.goods = objs;
        
        [weakSelf.collectionView reloadData];
        
        //加载headerView
        weakSelf.collectionView.headerView.user = weakSelf.currentUser;
        weakSelf.collectionView.headerView.headerBlock = ^(HomePageType type) {
            
            [weakSelf headerViewEventsWithType:type];
        };
        //统计我发布了多少商品
        [weakSelf getPublishNum];
        
        if ([TLUser user].isLogin) {
            
            //查询用户关系
            if (![self.userId isEqualToString:[TLUser user].userId]) {
                
                [self queryUserRelation];
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)getPublishNum {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808018";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //
        self.collectionView.headerView.publishNum = [responseObject[@"data"][@"totalProduct"] integerValue];
        
        self.collectionView.headerView.onNum = [responseObject[@"data"][@"totalOnProduct"] integerValue];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)queryUserRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805116";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"toUser"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //
        self.isFollow = [responseObject[@"data"] integerValue] == 1 ? YES: NO;
        
        self.collectionView.headerView.isFollow = self.isFollow;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
