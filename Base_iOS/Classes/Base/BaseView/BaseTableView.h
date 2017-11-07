//
//  BaseTableView.h
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/5.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@class BaseTableView;
@protocol RefreshTableViewDelegate <NSObject>

@optional
/**
 *  下拉刷新
 */
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView;
/**
 *  上拉刷新
 */
- (void)refreshTableViewPullUp:(id)refreshTableView;
/**
 *选中Cell时
 */
- (void)refreshTableView:(BaseTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */
- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index;

@end

@interface BaseTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;  //数据源
@property (nonatomic, strong) NSMutableArray *dataArrays;  //数据源2
@property (nonatomic, strong) NSMutableArray *selectGoods;  //数据源3

@property (nonatomic, weak)   id<RefreshTableViewDelegate> refreshDelegate;  //代理

@property (nonatomic, assign) BOOL refreshHeadEnable;  //上拉刷新开关

@property (nonatomic, assign) BOOL refreshFootEnable;  //下拉刷新开关

/**
 *  设置tableView刷新属性
 *
 *  @param refreshDelegate 刷新代理
 *  @param headEnable      是否开启下拉刷新
 *  @param footEnable      是否开启上拉加载
 *  @param autoRefresh     是否自动刷新
 */

- (void)setRefreshDelegate:(id<RefreshTableViewDelegate> _Nullable)refreshDelegate refreshHeadEnable:(BOOL)headEnable refreshFootEnable:(BOOL)footEnable autoRefresh:(BOOL)autoRefresh;
/**
 *  自动下拉刷新
 */
- (void)autoRefreshHead;
/**
 *  下拉刷新完成
 */
- (void)refreshHeadCompelete;
/**
 *  下拉刷新完成
 */
- (void)refreshFootCompelete;
/**
 *  上拉加载完成设置无数据状态
 */
- (void)noDataTips;
/**
 *  消除无数据状态
 */
- (void)resetDataTips;

@end
