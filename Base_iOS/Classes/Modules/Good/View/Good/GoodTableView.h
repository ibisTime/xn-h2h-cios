//
//  GoodTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "GoodModel.h"

typedef void(^GoodBlock)(NSIndexPath *indexPath);

@interface GoodTableView : TLTableView

@property (nonatomic, copy) GoodBlock goodBlock;

@property (nonatomic, strong) NSArray <GoodModel *>*goods;

@end
