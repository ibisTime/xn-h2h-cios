//
//  ZHGoodsVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsVC.h"
#import "ZHGoodsCell.h"
#import "ZHDefaultGoodsVC.h"
//#import "ZHShoppingCartVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "ZHSegmentView.h"
#import "ZHGoodsCategoryManager.h"
#import "ZHGoodsCategoryVC.h"

//#import "ZHCartManager.h"

#import "SearchVC.h"

@interface ZHGoodsVC ()<ZHSegmentViewDelegate>

@property (nonatomic,strong) UIScrollView *switchScrollView;
@property (nonatomic,strong) UIView *typeChangeView;
//@property (nonatomic,strong) UIButton *goShoppingCartBtn;
//@property (nonatomic,strong) UIView *reloaView;

@property (nonatomic,strong) ZHGoodsCategoryVC *zeroBuyVC;
//@property (nonatomic, strong) ZHSegmentView *segmentView;

@end


@implementation ZHGoodsVC


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"尖货";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];

    //去请求类别
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
  
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartCountChange) name:kShoopingCartCountChangeNotification object:nil];
    
 
    
}

- (void)tl_placeholderOperation {

    
    //获取分类接口
    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.showView = self.view;
    http.parameters[@"status"] = @"1";
    http.parameters[@"parentCode"] = @"FL201700000000000001";
    [http postWithSuccess:^(id responseObject) {
   
        [self removePlaceholderView];
        [ZHGoodsCategoryManager manager].dshjCategories = [ZHCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self setUpUI];

        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

        
    }];

}

- (void)search {
    
    SearchVC *searchVC = [[SearchVC alloc] init];
    searchVC.type = SearchVCTypeDefaultGoods;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

//}

#pragma mark- 剁手合集-小目标-0元试购：--：切换
- (BOOL)segmentSwitch:(NSInteger)idx {

    if (idx == 0) {
    
        //添加剁手合集 控制器
        static  ZHGoodsCategoryVC *dshjVC;

        if (!dshjVC) {
           
            dshjVC = [[ZHGoodsCategoryVC alloc] init];
            [self addChildViewController:dshjVC];
            dshjVC.smallCategories = [ZHGoodsCategoryManager manager].dshjCategories;
            [self.switchScrollView addSubview:dshjVC.view];
            
        }
  
    
    
    } else
    
    if (idx == 1) {
        
    
        
    } else
    
    
    if (idx == 2) {
        
        [self addChildViewController:self.zeroBuyVC];
        self.zeroBuyVC.smallCategories = [ZHGoodsCategoryManager manager].lysgCategories;
        self.zeroBuyVC.view.frame = self.switchScrollView.bounds;
        self.zeroBuyVC.view.x =kScreenWidth * 2;
        [self.switchScrollView addSubview:self.zeroBuyVC.view];
        
    }
    
    [self.switchScrollView setContentOffset:CGPointMake(idx*kScreenWidth, 0) animated:NO];
    
    return YES;

}

- (ZHGoodsCategoryVC *)zeroBuyVC {

    if (!_zeroBuyVC) {
        _zeroBuyVC = [[ZHGoodsCategoryVC alloc] init];
    }
    
    return _zeroBuyVC;
    
}


//- (UIButton *)goShoppingCartBtn {
//    
//    if (!_goShoppingCartBtn) {
//        
//        _goShoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 57,kScreenHeight -  110 - 10 - kNavigationBarHeight, 37, 37)];
//        [_goShoppingCartBtn setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
//        
//
//   
//        
//    }
//    return _goShoppingCartBtn;
//    
//}





- (void)setUpUI {

//    //顶部切换按钮
    CGFloat h = 45;
    CGFloat margin = 0.5;
    
    static  ZHGoodsCategoryVC *dshjVC;
    
    if (!dshjVC) {
        
        dshjVC = [[ZHGoodsCategoryVC alloc] init];
        [self addChildViewController:dshjVC];
        dshjVC.smallCategories = [ZHGoodsCategoryManager manager].dshjCategories;
        
        [self.view addSubview:dshjVC.view];
        self.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight);
        
    }
    
    //切换按钮
//    ZHSegmentView *segmentView = [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, h)];
//    segmentView.delegate = self;
//    segmentView.tagNames = @[@"剁手合集",@"小目标",@"0元试购"];
//    [self.view addSubview:segmentView];
//    self.typeChangeView = segmentView;
//    self.segmentView = segmentView;
    
    
//    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.typeChangeView.yy, kScreenWidth, kScreenHeight - kNavigationBarHeight - 49 - self.typeChangeView.yy)];
//    [self.view addSubview:self.switchScrollView];
//    self.switchScrollView.pagingEnabled = YES;
//    self.switchScrollView.contentSize = CGSizeMake(kScreenWidth * 3, self.switchScrollView.height);
//    self.switchScrollView.scrollEnabled = NO;

    
    //添加购物车--按钮
//    [self.view addSubview:self.goShoppingCartBtn];
    

}




@end
