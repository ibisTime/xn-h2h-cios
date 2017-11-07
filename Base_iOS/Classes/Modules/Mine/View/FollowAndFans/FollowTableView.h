//
//  FollowTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "FollowAndFansModel.h"

typedef void(^FollowBlock)(NSIndexPath *indexPath);

@interface FollowTableView : TLTableView

@property (nonatomic, copy) FollowBlock followBlock;

@property (nonatomic, strong) NSMutableArray <FollowAndFansModel *>*follows;

@end
