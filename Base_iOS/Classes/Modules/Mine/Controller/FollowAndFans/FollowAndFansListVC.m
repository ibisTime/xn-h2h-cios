//
//  FollowAndFansListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FollowAndFansListVC.h"
#import "FollowAndFansModel.h"

#import "FollowTableView.h"

#import "HomePageVC.h"

@interface FollowAndFansListVC ()

@property (nonatomic, strong) FollowTableView *tableView;
//关注和粉丝数据
@property (nonatomic,strong) NSMutableArray <FollowAndFansModel *>*models;
@property (nonatomic, assign) BOOL isFirst;
//暂无我关注的
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation FollowAndFansListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取商品列表
    [self requesGoodList];
    
    [self.tableView beginRefreshing];
    //刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];
    
}

#pragma mark - Init
- (void)initTableView {
    
    BaseWeakSelf;
    
    FollowTableView *extractedExpr = [[FollowTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight) style:UITableViewStylePlain];
    self.tableView = extractedExpr;
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.followBlock = ^(NSIndexPath *indexPath) {
        
        FollowAndFansModel *model = weakSelf.models[indexPath.row];
        
        HomePageVC *pageVC = [HomePageVC new];
        
        pageVC.userId = model.userId;
        
        [weakSelf.navigationController pushViewController:pageVC animated:YES];
    };
    
    [self.view addSubview:self.tableView];
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无消息");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    NSString *promptStr = _type == FollowAndFansTypeFollow ? @"还没有关注的人哦": @"还没有粉丝哦";
    
    UILabel *textLbl = [UILabel labelWithText:promptStr textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    
}

#pragma mark - Notification
- (void)refreshData {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events

#pragma mark - Data
- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805115";
    
    if (self.type == FollowAndFansTypeFollow) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
        
    } else if (self.type == FollowAndFansTypeFans) {
        
        helper.parameters[@"toUser"] = [TLUser user].userId;
        
    }
    
    helper.start = 1;
    helper.limit = 10;
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";

    helper.tableView = self.tableView;
    [helper modelClass:[FollowAndFansModel class]];
    
    [self.tableView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray <FollowAndFansModel *>*objs, BOOL stillHave) {
            
            weakSelf.models = objs;
            
            weakSelf.tableView.follows = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.models = objs;
            
            weakSelf.tableView.follows = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    //--//
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
