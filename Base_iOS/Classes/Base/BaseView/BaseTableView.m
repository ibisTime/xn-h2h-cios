//
//  BaseTableView.m
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/5.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.datas = [NSMutableArray array];
        self.dataArrays = [NSMutableArray array];
        self.selectGoods = [NSMutableArray array];
        [self _initWithTableView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.datas = [NSMutableArray array];
    [self _initWithTableView];
}

/**
 *  初始化 tableview
 */
- (void)_initWithTableView {
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = kWhiteColor;

}

- (void)setRefreshDelegate:(id<RefreshTableViewDelegate>)refreshDelegate refreshHeadEnable:(BOOL)headEnable refreshFootEnable:(BOOL)footEnable autoRefresh:(BOOL)autoRefresh {

    self.refreshDelegate = refreshDelegate;
    self.refreshHeadEnable = headEnable;
    self.refreshFootEnable = footEnable;
    if (autoRefresh) {
        [self autoRefreshHead];
    }
}

- (void)setRefreshHeadEnable:(BOOL)refreshHeadEnable {
    _refreshHeadEnable = refreshHeadEnable;
    if (self.refreshHeadEnable) {
        __weak typeof(self) weakSelf = self;
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshHeadCompelete];
        }];

    } else {
        if ([self.mj_header superview] != nil) {
            [self.mj_header removeFromSuperview];
        }
    }
}

- (void)setRefreshFootEnable:(BOOL)refreshFootEnable {
    _refreshFootEnable = refreshFootEnable;
    if (self.refreshFootEnable) {
        __weak typeof(self) weakSelf = self;
        
       self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           [weakSelf refreshFootCompelete];
       }];
        
        // 上拉加载footer显示
//        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf refreshFootCompelete];
//        }];
        
        MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter*)self.mj_footer;
        [footer setTitle:@"哎呀~~\n下面没有了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.numberOfLines = 0;
        
    }
    else {
        if ([self.mj_footer superview] != nil) {
            [self.mj_footer removeFromSuperview];
        }
    }
}

/**
 *  自动下拉刷新
 */
- (void)autoRefreshHead {
    [self.mj_header beginRefreshing];
}

/**
 *  下拉刷新完成
 */
- (void)refreshHeadCompelete {
    [self.mj_header endRefreshing];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewPullDown:)]) {
        [self.refreshDelegate refreshTableViewPullDown:self];
    }
}

/**
 *  上拉加载完成
 */
- (void)refreshFootCompelete {
    [self.mj_footer endRefreshing];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewPullUp:)]) {
        [self.refreshDelegate refreshTableViewPullUp:self];
    }
}

/**
 * 上拉加载完成设置无数据的状态
 */
- (void)noDataTips {
    [self.mj_footer endRefreshingWithNoMoreData];
}
/**
 *  消除无数据的状态
 */
- (void)resetDataTips {

    [self.mj_footer resetNoMoreData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark 设置cell分割线做对齐		cell底部线
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//}


@end
