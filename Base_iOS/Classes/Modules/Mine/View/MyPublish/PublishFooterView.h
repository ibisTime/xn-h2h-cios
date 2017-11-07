//
//  PublishFooterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, PublishEventsType) {
    
    PublishEventsTypeEdit = 0,       //编辑
    PublishEventsTypeOn,             //上架
    PublishEventsTypeOff,            //下架
    PublishEventsTypeDelete,         //删除
};

typedef void(^PublishEventsBlock)(PublishEventsType type);

@interface PublishFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign) PublishEventsType eventsType;

@property (nonatomic, copy) PublishEventsBlock publishBlock;

@property (nonatomic, strong) GoodModel *good;

@end
