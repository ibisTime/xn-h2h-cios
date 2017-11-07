//
//  CouponVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponVC.h"

#import "CouponListVC.h"
#import "HTMLStrVC.h"

#import "SelectScrollView.h"

@interface CouponVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation CouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIBarButtonItem addRightItemWithTitle:@"使用说明"  titleColor:kTextColor frame:CGRectMake(0, 0, 40, 20)  vc:self action:@selector(couponRemark)];

    [self initSelectScrollView];
    
    [self addSubViewController];

}

#pragma mark - Init
- (void)initSelectScrollView {
    
    self.titles = @[@"未使用", @"已使用", @"已过期"];

    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        CouponListVC *childVC = [[CouponListVC alloc] init];
        
        childVC.statusType = i;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
        //        [childVC startLoadData];
        
    }
}

#pragma mark - Events
- (void)couponRemark {
    
    HTMLStrVC *htmlVC = [HTMLStrVC new];
    
    htmlVC.type = HTMLTypeCouponExplain;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
