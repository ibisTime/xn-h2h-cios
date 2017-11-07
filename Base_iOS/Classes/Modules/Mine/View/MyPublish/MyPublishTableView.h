//
//  MyPublishTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, PublishType) {
    
    PublishTypeClickCell = 0,   //查看详情
    PublishTypeEdit,            //编辑
    PublishTypeOff,             //下架
    PublishTypeOn,              //上架
    PublishTypeDelete,          //删除
};

typedef void(^PublishBlock)(PublishType publishType, GoodModel *good, NSInteger section);

@interface MyPublishTableView : TLTableView

@property (nonatomic, copy) PublishBlock publishBlock;

@property (nonatomic, strong) NSMutableArray <GoodModel *>*goods;

@end
