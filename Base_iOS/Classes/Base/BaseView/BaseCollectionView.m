//
//  BaseCollectionView.m
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/13.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseCollectionView.h"
#import "MJRefresh.h"

#define identifierDeafaultCollect @"identifierDeafaultCollect"

@interface BaseCollectionView ()

@property (nonatomic, copy) void(^refresh)();
/**
 * 上拉加载更多
 */
@property (nonatomic, copy) void(^loadMore)();

@end

@implementation BaseCollectionView
{
    UIView *_placeholderV;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self _initWithCollectionView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initWithCollectionView];
}

/**
 *  初始化 collectionview
 */
- (void)_initWithCollectionView {
    
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = kWhiteColor;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierDeafaultCollect];
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

@end
