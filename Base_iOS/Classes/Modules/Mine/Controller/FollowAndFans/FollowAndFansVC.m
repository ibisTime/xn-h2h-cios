//
//  FollowAndFansVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FollowAndFansVC.h"
#import "SelectScrollView.h"

@interface FollowAndFansVC ()

@property (nonatomic, strong) SelectScrollView *selectScrollView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation FollowAndFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSelectScrollView];
    
    [self addSubViewController];
    
}

#pragma mark - Init
- (void)initSelectScrollView {
    
    NSString *follow = [NSString stringWithFormat:@"我的关注(%ld)", [[TLUser user].totalFollowNum integerValue]];
    
    NSString *fans = [NSString stringWithFormat:@"我的粉丝(%ld)", [[TLUser user].totalFansNum integerValue]];

    self.titles = @[follow, fans];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles];
    
    self.selectScrollView.currentIndex = self.type;
    
    [self.view addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        FollowAndFansListVC *childVC = [[FollowAndFansListVC alloc] init];
        
        childVC.type = i;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [_selectScrollView.scrollView addSubview:childVC.view];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
