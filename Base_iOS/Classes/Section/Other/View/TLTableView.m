//
//  BaseMJRefreshTableView.m
//  Witness
//
//  Created by 田磊 on 15/12/8.
//  Copyright © 2015年 Ancun. All rights reserved.
//

#import "TLTableView.h"
#import "MJRefresh.h"
#import <UIScrollView+TLAdd.h>

@interface TLTableView ()

@property (nonatomic, copy) void(^refresh)();
/**
 * 上拉加载更多
 */
@property (nonatomic, copy) void(^loadMore)();
//@property (nonatomic, copy) UIView *(^placeholderView)();
///*can scroll when placeholderView is exists default yes*/
//@property (nonatomic, copy) BOOL (^scrollEnabled_ac)();
///*can scroll when placeholderView is notExists default yes*/
//@property (nonatomic, copy)   BOOL (^scrollWasEnabled_ac)();


@end


@implementation TLTableView
{
    UIView *_placeholderV;
}

+ (instancetype)groupTableViewWithFrame:(CGRect)frame

                               delegate:(id)delegate dataSource:(id)dataSource {

    
    TLTableView *tableView = [[TLTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [tableView adjustsContentInsets];
    
    return tableView;

}


+ (instancetype)tableViewWithFrame:(CGRect)frame

                              delegate:(id)delegate dataSource:(id)dataSource
{

    TLTableView *tableView = [[TLTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [tableView adjustsContentInsets];

    return tableView;

}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = kBackgroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        [self adjustsContentInsets];
        
    }
    
    //    return [GoodTableView tableViewWithFrame:frame delegate:self dataSource:self];
    return self;
}

//刷新
- (void)addRefreshAction:(void (^)())refresh
{
    self.refresh = refresh;
    
   
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:self.refresh];
    self.mj_header = header;
}

- (void)addLoadMoreAction:(void (^)())loadMore
{
    
    self.loadMore = loadMore;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:loadMore];
    
    UIImageView *logo = [[UIImageView  alloc] initWithFrame:footer.bounds];
    logo.image = [UIImage imageNamed:@"logo_small"];
    [footer addSubview:logo];
    footer.arrowView.hidden = YES;
    self.mj_footer = footer;
    
}


- (void)beginRefreshing
{
    if (self.mj_header == nil) {
        return;
    }
    [self.mj_header beginRefreshing];

}

- (void)endRefreshHeader
{

    if (self.mj_header == nil) {

    }else{
        
        [self.mj_header endRefreshing];
    }
   
}

- (void)endRefreshFooter
{
    if (!self.mj_footer) {
        NSLog(@"刷新尾部组件不存在");
        return;
    }
    [self.mj_footer endRefreshing];
}

- (void)endRefreshingWithNoMoreData_tl
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetNoMoreData_tl
{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }

}

- (void)setHiddenFooter:(BOOL)hiddenFooter
{
    _hiddenFooter = hiddenFooter;
    if (self.mj_footer) {
                self.mj_footer.hidden = hiddenFooter;
            }else{
                NSLog(@"footer不存在");
            }
}

- (void)setHiddenHeader:(BOOL)hiddenHeader
{
    _hiddenHeader = hiddenHeader;
    if (self.mj_header) {
        
        self.mj_header.hidden = hiddenHeader;
        
    }else{
        NSLog(@"header不存在");
    }
}



-(void)reloadData_tl
{
    [super reloadData];
    
    long sections = 1;//默认为1组
    BOOL isEmpty = YES; //判断数据是否为空
    
    //1.多少分组
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
        
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    //2.每组多少Row，进儿判断数据是否为空
    for ( int i = 0; i < sections; i++) {
        long numOfRow = 0;
        
        if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
            
            numOfRow = [self.dataSource tableView:self numberOfRowsInSection:i];
        }

        if (numOfRow > 0) { //只要有一组有数据就不为空
            isEmpty = NO;
        }
        
    }
    
    //没有实现方法抛出异常
//    if (!self.placeholderView) {
//        
//        @throw [NSException exceptionWithName:@"this unException the ACTableView object" reason:@"please achieve createPlaceholderView: scrollEnabled: scrollWasEnabled:" userInfo:nil];
//    }
    
    if (isEmpty == YES) {
        
//        [_placeholderV removeFromSuperview];
//        _placeholderV = nil;
//        [[_placeholderV subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//
//        _placeholderV = _placeholderView();
//        [self addSubview:_placeholderV];
        
        if (self.tableHeaderView) {
            
            if (self.placeHolderView.y <  self.tableHeaderView.height) {
                
                   self.placeHolderView.y =   self.placeHolderView.y  + self.tableHeaderView.height;
            }
         
            
        }
        
//        [self addSubview:self.placeHolderView];
        self.tableFooterView = self.placeHolderView;
        self.placeHolderView.width = self.width;
        self.placeHolderView.centerX = self.width/2.0;

        
    }else{
        
        [self.placeHolderView removeFromSuperview];
//        [_placeholderV removeFromSuperview];
//        _placeholderV = nil;
//        [[_placeholderV subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    }
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
