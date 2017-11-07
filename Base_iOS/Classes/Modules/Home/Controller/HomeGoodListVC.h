//
//  HomeGoodListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,HomeGoodStatus) {
    
    HomeGoodStatusHotGood = 0,      //热门推荐
    HomeGoodStatusNearbyGood,       //附近商品
    
};

@interface HomeGoodListVC : BaseViewController

@property (nonatomic,assign) HomeGoodStatus status;


@end
