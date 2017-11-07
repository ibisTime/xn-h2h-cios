//
//  ZHShoppingListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingListVC.h"
#import "ZHSegmentView.h"
#import "ZHShoppingListCategoryVC.h"

@interface ZHShoppingListVC ()<ZHSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollV;

@property (nonatomic,strong) ZHShoppingListCategoryVC *allVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *willPayVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *didPayVC;
@property (nonatomic,strong) ZHShoppingListCategoryVC *willSendVC;


@property (nonatomic,strong) NSMutableArray *isAdd;

@end

@implementation ZHShoppingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"商品订单"];
    
    ZHSegmentView *segmentView =  [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 45)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"全部",@"待支付",@"待发货",@"待收货"];
    self.isAdd = [@[@1, @0, @0, @0] mutableCopy];
    
    //
    UIScrollView *switchScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy + 0.5, kScreenWidth, kScreenHeight - kNavigationBarHeight - segmentView.yy)];
    switchScrollV.pagingEnabled = YES;
    switchScrollV.contentSize = CGSizeMake(kScreenWidth * 3, switchScrollV.height);
    [self.view addSubview:switchScrollV];
    self.switchScrollV = switchScrollV;
    switchScrollV.scrollEnabled = NO;
    
    //
    [self addChildViewController:self.allVC];
    
}
- (ZHShoppingListCategoryVC *)willSendVC {

    if (!_willSendVC) {
        
        _willSendVC = [[ZHShoppingListCategoryVC alloc] init];
        _willSendVC.status = ZHOrderStatusWillSend;
        _willSendVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, self.switchScrollV.height);
        
        [self.switchScrollV addSubview:_willSendVC.view];
    }
    return _willSendVC;

}
- (ZHShoppingListCategoryVC *)allVC {

    if (!_allVC) {
        _allVC = [[ZHShoppingListCategoryVC alloc] init];
        
        _allVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.switchScrollV.height);
//        _allVC.status = ZHOrderStatusAll;
        [self.switchScrollV addSubview:_allVC.view];

    }
    return _allVC;
}

- (ZHShoppingListCategoryVC *)willPayVC {
    
    if (!_willPayVC) {
        _willPayVC = [[ZHShoppingListCategoryVC alloc] init];
        

        _willPayVC.status = ZHOrderStatusWillPay;
//        _willPayVC.statusCode = @"1";
        _willPayVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.switchScrollV.height);

    }
    return _willPayVC;
}

- (ZHShoppingListCategoryVC *)didPayVC {

    if (!_didPayVC) {
        _didPayVC = [[ZHShoppingListCategoryVC alloc] init];
        
        _didPayVC.status = ZHOrderStatusDidPay;
        _didPayVC.view.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, self.switchScrollV.height);
//        _didPayVC.statusCode = @"2";
    }
    return _didPayVC;


}

- (BOOL)segmentSwitch:(NSInteger)idx {

    [self.switchScrollV setContentOffset:CGPointMake(idx*kScreenWidth, 0) animated:YES];
    if (idx == 0) {
        
    } else if( idx == 1 ) {
        
        if ([self.isAdd[1] isEqual:@0]) {
            
            [self addChildViewController:self.willPayVC];
            [self.switchScrollV addSubview:_willPayVC.view];

        } else {
        
            self.isAdd[1] = @1;
        }
        
    } else if(idx == 2) {
    
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.willSendVC];
            [self.switchScrollV addSubview:_willSendVC.view];
            
        } else {
            
            self.isAdd[idx] = @1;
        }
    
    } else {
        
        if ([self.isAdd[idx] isEqual:@0]) {
            
            [self addChildViewController:self.didPayVC];
            [self.switchScrollV addSubview:_didPayVC.view];

            
        } else {
            
            self.isAdd[idx] = @1;
        }
        
//        [self addChildViewController:self.didPayVC];
        
    }
    
    return YES;
}
@end
