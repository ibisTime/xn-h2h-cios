//
//  CircleVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CircleVC.h"

#import "CircleTableView.h"

#import "GoodModel.h"

#import "GoodDetailVC.h"
#import "HomePageVC.h"

@interface CircleVC ()

@property (nonatomic, strong) CircleTableView *tableView;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*circleList;

@end

@implementation CircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self initTableView];
    //获取圈子
    [self requestCircleList];
    
    [self.tableView beginRefreshing];
    //通知
    [self addNotification];
}

#pragma mark - Init
- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[CircleTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.circleBlock = ^(NSInteger index, CircleEventsType type) {
        
        [weakSelf circleEventsWithIndex:index type:type];
    };
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCircleData) name:@"RefreshCircleData" object:nil];
}

#pragma mark - Events
- (void)circleEventsWithIndex:(NSInteger)index type:(CircleEventsType)type {
    
    GoodModel *good = self.circleList[index];

    switch (type) {
        case CircleEventsTypeHomePage:
        {
            HomePageVC *pageVC = [HomePageVC new];
            
            pageVC.userId = good.storeCode;
            
            [self.navigationController pushViewController:pageVC animated:YES];
        }break;
            
            
        case CircleEventsTypeDetail:
        {
            
            GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
            
            detailVC.code = good.code;
            detailVC.userId = good.storeCode;

            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)refreshCircleData {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Data
- (void)requestCircleList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808025";
    
    helper.parameters[@"status"] = @"3";
    helper.parameters[@"isPublish"] = @"1";
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    //是否参加活动
    helper.parameters[@"isJoin"] = @"0";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    [self.tableView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
            
            weakSelf.circleList = objs;
            
            weakSelf.tableView.circleList = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.circleList = objs;
            
            weakSelf.tableView.circleList = objs;

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
