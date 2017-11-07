//
//  HomePageCollectionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "HomePageHeaderView.h"

typedef void(^HomePageBlock)(NSIndexPath *indexPath);

@interface HomePageCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <GoodModel *>*goods;
//头部
@property (nonatomic, strong) HomePageHeaderView *headerView;

@property (nonatomic, copy) HomePageBlock homePageBlock;

@end
