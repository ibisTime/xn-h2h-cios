//
//  MyPublishListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,GoodStatus) {
    
    GoodStatusPublished = 0,         //我发布的
    GoodStatusPublishOff = 1,        //已下架
    
};

@interface MyPublishListVC : BaseViewController

@property (nonatomic,assign) GoodStatus status;

@end
