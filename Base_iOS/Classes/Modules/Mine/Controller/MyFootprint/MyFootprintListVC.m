//
//  MyFootprintListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyFootprintListVC.h"
#import "GoodTableView.h"
#import "GoodListCell.h"

#import "WantModel.h"
#import "GoodModel.h"

#import "GoodDetailVC.h"

@interface MyFootprintListVC ()

@property (nonatomic, strong) GoodTableView *tableView;

@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic, assign) BOOL isFirst;
//暂无我的足迹
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation MyFootprintListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirst = YES;
    
    self.goods = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];
    
    [self initPlaceHolderView];
    //商品
    [self initTableView];
    //获取商品列表
    [self requesGoodList];
    
    [self.tableView beginRefreshing];
    
}

#pragma mark - Init

- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[GoodTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight)];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.goodBlock = ^(NSIndexPath *indexPath) {
        
        GoodModel *good = weakSelf.goods[indexPath.row];
        
        GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
        
        detailVC.code = good.code;
        detailVC.userId = good.storeCode;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    [self.view addSubview:self.tableView];
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"还没有足迹哦" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

#pragma mark - Notification
- (void)refreshData {
    
    [self.tableView beginRefreshing];
}

- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808950";
    
    helper.parameters[@"category"] = @"P";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"type"] = @"3";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    [helper modelClass:[WantModel class]];
    
    self.pageDataHelper = helper;
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <WantModel *>*objs, BOOL stillHave) {
            
            [weakSelf convertModelWithWantModels:objs];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    //--//
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

#pragma mark - Events
- (void)convertModelWithWantModels:(WantModel *)objs {
    
    NSMutableArray <GoodModel *>*goods = [NSMutableArray array];

    NSArray <WantModel *>*arr = [objs copy];
    
    [arr enumerateObjectsUsingBlock:^(WantModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.product) {
            
            WantProduct *product = obj.product;
            
            GoodModel *good = [GoodModel new];
            
            good = (GoodModel *)product;
            
            [goods addObject:good];
        }
        
    }];
    
    self.goods = goods;
    
    self.tableView.goods = goods;
    
    [self.tableView reloadData_tl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
