//
//  CircleTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, CircleEventsType) {
    
    CircleEventsTypeHomePage = 0,   //个人主页
    CircleEventsTypeDetail,         //详情
    
};

typedef void(^CircleBlock)(NSInteger index, CircleEventsType type);

@interface CircleTableView : TLTableView

@property (nonatomic, copy) CircleBlock circleBlock;

@property (nonatomic, strong) NSMutableArray <GoodModel *>*circleList;

@end
