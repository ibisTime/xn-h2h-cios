//
//  CategoryVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CategoryVC.h"

#import "ShopTypeView.h"
#import "GoodTableView.h"
#import "GoodListCell.h"
#import "UIView+Custom.h"

#import "ShopTypeModel.h"
#import "GoodModel.h"

#import "GoodDetailVC.h"
#import "FilterVC.h"
#import <PYSearch.h>
#import "NavigationController.h"
#import "FilterVC.h"

@interface CategoryVC ()<PYSearchViewControllerDelegate>

@property (nonatomic, strong) ShopTypeView *shopTypeView;
//类型数据
@property (nonatomic, strong) NSArray <PublishCategoryModel *>*categoryArr;

@property (nonatomic, strong) GoodTableView *tableView;

@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirst = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];
    //搜索
    [self initSearchBar];
    //商品
    [self initTableView];
    //获取商品列表
    [self requesGoodList];
    
    [self.tableView beginRefreshing];

}

#pragma mark - Init
- (void)initSearchBar {
    
    self.view.backgroundColor = kWhiteColor;
    
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    self.navigationItem.titleView = searchBgView;
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
        
    }];
    //搜索按钮
    UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:[UIColor textColor] backgroundColor:[UIColor colorWithHexString:@"#f3f4f8"] titleFont:15.0 cornerRadius:15.0];
    
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(7, 0, 7, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 30);

    }];
    
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.width + 50)];
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(14)
                                       textColor:[UIColor textColor2]];
    [searchBgView addSubview:searchLbl];
    searchLbl.text = @"搜索";
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX).offset(0);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];
}

- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[GoodTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight - kBottomInsetHeight)];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品" topMargin:42];

    self.tableView.goodBlock = ^(NSIndexPath *indexPath) {
    
            GoodModel *good = weakSelf.goods[indexPath.row];
        
            GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
        
            detailVC.code = good.code;
            detailVC.userId = good.storeCode;

            [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    [self.view addSubview:self.tableView];
}

- (ShopTypeView *)shopTypeView {
    
    if (!_shopTypeView) {
        
        BaseWeakSelf;
        
        _shopTypeView = [[ShopTypeView alloc] init];
        
        _shopTypeView.typeBlock = ^(NSString *code, NSInteger index) {
            
            FilterVC *filterVC = [[FilterVC alloc] init];
            
            filterVC.type = FilterVCTypeCategory;
            
            filterVC.category = weakSelf.categoryArr[index];
            
            filterVC.returnBlock = ^{
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
            
            [weakSelf.navigationController pushViewController:filterVC animated:YES];
            
        };
        
        self.tableView.tableHeaderView = _shopTypeView;
    }
    return _shopTypeView;
}

#pragma mark - Notification
- (void)refreshData {
    
    [self.tableView beginRefreshing];
}

#pragma mark - 获得店铺类型
- (void)getType {
    
    //presentCode: 0一级分类  1二级分类
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808007";
    if (_isFirst) {
        
        http.showView = self.view;
    }
    
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"4";
    http.parameters[@"parentCode"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        _isFirst = NO;
        
        self.categoryArr = [ShopTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //1.获取数据
        self.shopTypeView.typeModels = [ShopTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.shopTypeView.height += 10;
        
        self.tableView.tableHeaderView = self.shopTypeView;

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808025";
    
    helper.parameters[@"status"] = @"3";
    helper.parameters[@"isJoin"] = @"0";
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    [self.tableView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            //获取商品类型
            [weakSelf getType];
            
            weakSelf.tableView.goods = objs;
            
            [weakSelf.tableView reloadData_tl];
            
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
    
//    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;

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

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
//            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
//                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
//                [searchSuggestionsM addObject:searchSuggestion];
//            }
//            // Refresh and display the search suggustions
//            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
