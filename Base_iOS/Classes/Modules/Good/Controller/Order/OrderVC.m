//
//  OrderVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderVC.h"

#import "SelectScrollView.h"

#import "OrderListVC.h"

@interface OrderVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    
    [self initSelectScrollView];
    
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"全部", @"待支付", @"待发货", @"待收货", @"待评价", @"已完成"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    self.selectScrollView.currentIndex = self.currentIndex;
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        OrderListVC *childVC = [[OrderListVC alloc] init];
        
        childVC.status = i;

        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
        //        [childVC startLoadData];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
