//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"
#import "PublishVC.h"
#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import "TLUserLoginVC.h"
#import "CustomTabBar.h"

@interface TabbarViewController () <UITabBarControllerDelegate, TabBarDelegate>


@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, strong) CustomTabBar *customTabbar;


@end

@implementation TabbarViewController

- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
//    if (![vcName hasSuffix:@"VC"]) {
//        vcName = [NSString stringWithFormat:@"%@VC", vcName];
//    }
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    
    
    vc.navigationItem.titleView = [UILabel labelWithTitle:title];
    
    vc.tabBarItem = tabBarItem;
    
    TabBarModel *item = [TabBarModel new];
    
    item.selectedImgUrl = imgSelected;
    item.unSelectedImgUrl = imgNormal;
    item.title = title;
    
    [self.tabBarItems addObject:item];
    
    return nav;
}


- (void)createSubControllers {
    
    NSArray *titles = @[@"首页", @"分类", @"发布", @"消息", @"我的"];
    
    NSArray *normalImages = @[@"home", @"category", @"publish", @"notice", @"mine"];
    
    NSArray *selectImages = @[@"home_select", @"category_select", @"publish_select", @"notice_select", @"mine_select"];
    
    NSArray *vcNames = @[@"HomeVC", @"CategoryVC", @"PublishVC", @"ConversationListViewController", @"MineVC"];
    
    self.tabBarItems = [NSMutableArray array];
    
    // 首页
    NavigationController *homeNav = [self createNavWithTitle:titles[0] imgNormal:normalImages[0] imgSelected:selectImages[0] vcName:vcNames[0]];
    
    // 分类
    NavigationController *categoryNav = [self createNavWithTitle:titles[1] imgNormal:normalImages[1] imgSelected:selectImages[1] vcName:vcNames[1]];
    
    // 发布
//    NavigationController *nearbyNav = [self createNavWithTitle:titles[2] imgNormal:normalImages[2] imgSelected:selectImages[2] vcName:vcNames[2]];
    
    // 消息
    NavigationController *noticeNav = [self createNavWithTitle:titles[3] imgNormal:normalImages[3] imgSelected:selectImages[3] vcName:vcNames[3]];
    
    // 我的
    NavigationController *mineNav = [self createNavWithTitle:titles[4] imgNormal:normalImages[4] imgSelected:selectImages[4] vcName:vcNames[4]];
    
    self.viewControllers = @[homeNav, categoryNav, noticeNav, mineNav];
}


// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
    
    return _msgLabel;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // 创建子控制器
    [self createSubControllers];
    
    [self initTabBar];
    
    //退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)initTabBar {
    
    //替换系统tabbar
    CustomTabBar *tabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.translucent = NO;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor orangeColor];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [tabBar layoutSubviews];
    
    self.customTabbar = tabBar;
    
    tabBar.tabBarItems = self.tabBarItems.copy;
    
}

#pragma mark - Events
- (void)addArticleOnClick:(UIButton*)button {
    
    
    //    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    // [nav.view addSubview:addVoaygeView];
    
    //    PublishViewController *publishVC = [[PublishViewController alloc] init];
    //    NavigationController *pubNav = [[NavigationController alloc] initWithRootViewController:publishVC];
    //
    //
    //    [nav presentViewController:pubNav animated:YES completion:nil];
}

- (void)userLogout {
    
    self.tabBar.items[3].badgeValue =  nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {
    
    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    self.customTabbar.selectedIdx = _currentIndex;
    
    self.selectedIndex = _currentIndex;
}

#pragma mark- tabbar-delegate
- (BOOL)didSelected:(NSInteger)idx tabBar:(UITabBar *)tabBar {
    
    if ((idx == 2 || idx == 3) && ![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    //
    self.selectedIndex = idx;
    
    return YES;
    
}

- (BOOL)didSelectedMiddleItemTabBar:(CustomTabBar *)tabBar {
    
    BaseWeakSelf;
    
    if ([TLUser user].isLogin) {
        
        PublishVC *publishVC = [PublishVC new];
        
        publishVC.publishSuccess = ^{
            
            weakSelf.currentIndex = 1;
        };
        
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:publishVC];
        [self presentViewController:navi animated:YES completion:nil];
        
        return YES;
    }
    
    TLUserLoginVC *loginVC = [TLUserLoginVC new];
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navi animated:YES completion:nil];
    
    return NO;
    
}

//IM
- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    NavigationViewController *curNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:self.selectedIndex];
    if (self.selectedIndex == 2)
    {
        // 选的中会话tab
        // 先检查当前栈中是否聊天界面
        NSArray *array = [curNav viewControllers];
        for (UIViewController *vc in array)
        {
            if ([vc isKindOfClass:[IMAChatViewController class]])
            {
                // 有则返回到该界面
                IMAChatViewController *chat = (IMAChatViewController *)vc;
                [chat configWithUser:user];
                //                chat.hidesBottomBarWhenPushed = YES;
                [curNav popToViewController:chat animated:YES];
                return;
            }
        }
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        
        if ([user isC2CType])
        {
            TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.userId];
            if ([imconv getUnReadMessageNum] > 0)
            {
                [vc modifySendInputStatus:SendInputStatus_Send];
            }
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [curNav pushViewController:vc withBackTitle:@"返回" animated:YES];
    }
    else
    {
        NavigationViewController *chatNav = (NavigationViewController *)[[self viewControllers] objectAtIndex:0];
        
#if kTestChatAttachment
        // 无则重新创建
        ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
        ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
        vc.hidesBottomBarWhenPushed = YES;
        [chatNav pushViewController:vc withBackTitle:@"返回" animated:YES];
        
        [self setSelectedIndex:2];
        self.currentIndex = 2;
        
        if (curNav.viewControllers.count != 2)
        {
            [curNav popToRootViewControllerAnimated:YES];
        }
        
    }
}
@end
