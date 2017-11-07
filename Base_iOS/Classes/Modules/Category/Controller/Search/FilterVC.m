//
//  FilterVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "FilterVC.h"

#import "GoodListCell.h"
#import "FilterTopView.h"

#import "GoodModel.h"

#import "GoodDetailVC.h"

#import "UIView+Custom.h"
#import "TabbarViewController.h"
#import <PYSearch.h>
#import "NavigationController.h"

@interface FilterVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, PYSearchViewControllerDelegate>

//普通商品搜索
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic,strong) TLTableView *tableView;
//筛选
@property (nonatomic, strong) FilterTopView *filterTopView;

@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    [self initReturnBtn];
    //搜索
    [self initSearchBar];
    //筛选
    [self initFilterView];
    //商品列表
    [self initTableView];
    //获取商品数据
    [self requestGoodList];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];

    
}

#pragma mark - Init
- (void)initReturnBtn {
    
    UIButton *returnBtn = [UIButton buttonWithImageName:@"返回"];
    
    returnBtn.frame = CGRectMake(-10, 0, 40, 44);
    
    [returnBtn setTitleRight];
    
    [returnBtn addTarget:self action:@selector(clickReturn) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:returnBtn.bounds];
    
    [customView addSubview:returnBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
}

- (void)initSearchBar {
    
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
//    UIView *searchBgView = [[UIView alloc] init];

    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    
    self.navigationItem.titleView = searchBgView;

    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
    }];
//    //搜索按钮
    UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:[UIColor textColor] backgroundColor:[UIColor colorWithHexString:@"#f3f4f8"] titleFont:15.0 cornerRadius:15.0];
//
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 8, 0));

        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15);
        
    }];
//
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.width + 50)];
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(14)
                                       textColor:[UIColor textColor2]];
    [searchBgView addSubview:searchLbl];

    searchLbl.text = self.category ? self.category.name: @"搜索";
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX).offset(0);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];

}

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, self.filterTopView.yy, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - self.filterTopView.height) delegate:self dataSource:self];
    
    [tableView registerClass:[GoodListCell class] forCellReuseIdentifier:@"GoodListCell"];
    
    tableView.rowHeight = [GoodListCell rowHeight];

    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无结果"];

    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}

- (void)initFilterView {
    
    BaseWeakSelf;
    
    [FilterManager manager].category = self.category;
    
    self.filterTopView = [[FilterTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    self.filterTopView.backgroundColor = kWhiteColor;

    self.filterTopView.filterBlock = ^() {
        
        [weakSelf filterEvents];
    };
    
    [self.view addSubview:self.filterTopView];
    
}

#pragma mark - Events

- (void)clickReturn {
    
    [self.filterTopView.addressView hide];
    
    [self.filterTopView.categoryView hide];
    
    if (self.type == FilterVCTypeCategory || self.type == FilterVCTypeCouponGood) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (self.type == FilterVCTypeSearch) {
        
        TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
        
        tabbarVC.currentIndex = 1;
        
        if (_returnBlock) {
            
            _returnBlock();
        }
        
    }
    
}

- (void)clickSearch {
    
    BaseWeakSelf;
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"输入关键字搜索", @"输入关键字搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        FilterVC *filterVC = [[FilterVC alloc] init];
        filterVC.type = FilterVCTypeSearch;
        filterVC.searchText = searchText;
        
        filterVC.returnBlock = ^{
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        [searchViewController.navigationController pushViewController:filterVC animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.showHotSearch = NO;
    
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    
    searchViewController.searchBarBackgroundColor = [UIColor colorWithHexString:@"#f3f4f8"];
    
    __weak UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextColor backgroundColor:kClearColor titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    
    searchViewController.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIView* backgroundView = [searchViewController.searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
    
    backgroundView.layer.cornerRadius = 22;
    backgroundView.clipsToBounds = YES;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)clickCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    
}

- (void)filterEvents {
    
    FilterManager *filter = [FilterManager manager];

    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808025";
    
    helper.parameters[@"status"] = @"3";
    
    //是否参加优惠活动 1:是 0:否
    helper.parameters[@"isJoin"] = self.type == FilterVCTypeCouponGood ? @"1": @"0";

    if (self.searchText) {
        
        helper.parameters[@"name"] = self.searchText;
        
    }
    
    if (filter.area) {
        
        helper.parameters[@"province"] = filter.province;
        helper.parameters[@"city"] = filter.city;
        helper.parameters[@"area"] = filter.area;
    }
    
    if (filter.category) {
        
        if (![filter.category.name isEqualToString:@"全部"]) {
            
            NSString *string = filter.isCategory == YES ? @"category": @"type";
            
            helper.parameters[string] = filter.category.code;

        }
    }
    
    if (filter.maxPrice) {
        
        helper.parameters[@"maxPrice"] = [filter.maxPrice convertToSysMoney];
    }
    
    if (filter.minPrice) {
        
        helper.parameters[@"minPrice"] = [filter.minPrice convertToSysMoney];
    }
    
    if (filter.isNew == YES) {
        
        helper.parameters[@"isNew"] = @"1";

    }
    
    if (filter.isFreight == YES) {
        
        helper.parameters[@"yunfei"] = @"0";

    }
    
    helper.parameters[@"orderColumn"] = @"price";
    helper.parameters[@"orderDir"] = filter.isAsc == YES ? @"asc": @"desc";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - Data
- (void)requestGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808025";
    helper.showView = self.view;
    
    helper.parameters[@"status"] = @"3";
    
    if (self.searchText) {
        
        helper.parameters[@"name"] = self.searchText;
    }
    
    if (self.category) {
        
        helper.parameters[@"category"] = self.category.code;
    }
    
    //是否参加优惠活动 1:是 0:否
    helper.parameters[@"isJoin"] = self.type == FilterVCTypeCouponGood ? @"1": @"0";
    
    helper.parameters[@"orderColumn"] = @"price";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
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

#pragma mark - UITableViewDasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *goodsCellId = @"GoodListCell";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
    
    cell.isCoupon = self.type == FilterVCTypeCouponGood ? YES: NO;

    cell.goodModel = self.goods[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
    
    detailVC.code = self.goods[indexPath.row].code;
    detailVC.userId = self.goods[indexPath.row].storeCode;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , 10)];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)dealloc {
    
    [[FilterManager manager] clearManager];
}
@end
