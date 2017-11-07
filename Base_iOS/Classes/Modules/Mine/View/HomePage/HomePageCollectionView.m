//
//  HomePageCollectionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomePageCollectionView.h"
#import "HomePageCell.h"

@interface HomePageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic,assign)CGFloat headerImgHeight;
/**
 *  放大比例
 */
@property (nonatomic,assign)CGFloat scale;

@end

@implementation HomePageCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = kBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[HomePageCell class] forCellWithReuseIdentifier:@"HomePageCellId"];
        
        [self registerClass:[HomePageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCellId"];
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //--//
    return self.goods.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    HomePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCellId" forIndexPath:indexPath];
    
    cell.goodModel  = self.goods[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_homePageBlock) {
        
        _homePageBlock(indexPath);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *HeaderCellId = @"HeaderCellId";

    HomePageHeaderView *cell = (HomePageHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCellId forIndexPath:indexPath];
    
    self.headerView = cell;
    
    self.scale =  self.headerView.bgIV.frame.size.width / self.headerView.bgIV.frame.size.height;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 280 + 10 + 50);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        
        return ;
    }
}

@end
