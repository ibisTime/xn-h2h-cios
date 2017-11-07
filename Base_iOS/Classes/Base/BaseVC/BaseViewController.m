//
//  BaseViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

#import "NavigationController.h"

#import "TabbarViewController.h"

//#import "LoginViewController.h"

#define kAnimationType 1


@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *placeholderTitleLbl;

@property (nonatomic, strong) UIButton *opBtn;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    [self setViewEdgeInset];
    
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kWhiteColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    TabbarViewController *tabbar = (TabbarViewController*)self.tabBarController;
    if (tabbar) {
       // [tabbar removeOriginTabbarButton];
    }
}

- (UIScrollView *)bgSV {
    
    if (!_bgSV) {
        
        _bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
        
        _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
        
        [self.view addSubview:_bgSV];
    }
    
    return _bgSV;
    
}

#pragma mark - Setting
- (void)setTitle:(NSString *)title {
    
    self.navigationItem.titleView = [UILabel labelWithTitle:title];
}

#pragma mark - Private

// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (BOOL)isRootViewController {
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - Public
- (void)returnButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showReLoginVC {
    
    
    //    LoginViewController *loginVC = [[LoginViewController alloc] init];
    //    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    //    [self presentViewController:nav animated:YES completion:nil];
}

- (void)addPlaceholderView {
    
    if (self.placeholderView) {
        
        [self.view addSubview:self.placeholderView];
        
    }
    
}

- (void)removePlaceholderView {
    
    if (self.placeholderView) {
        
        [self.placeholderView removeFromSuperview];
        
    }
    
}

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)opTitle {
    
    if (self.placeholderView) {
        
        _placeholderTitleLbl.text = title;
        [_opBtn setTitle:opTitle forState:UIControlStateNormal];
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(16) textColor:[UIColor zh_textColor]];
        [view addSubview:lbl];
        lbl.text = title;
        _placeholderTitleLbl = lbl;
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(14);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        _opBtn = btn;
        _placeholderView = view;
        
    }
    
}

- (UIView *)placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle {
    
    if (!_placeholderView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:18.0];
        
        lbl.frame = CGRectMake(0, 100, view.width, 50);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        
        [view addSubview:lbl];
        lbl.text = title;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        
        _placeholderView = view;
    }
    return _placeholderView;
    
}

#pragma mark- 站位操作
- (void)placeholderOperation {
    
    if ([self isMemberOfClass:NSClassFromString(@"TLBaseVC")]) {
        
        NSLog(@"子类请重写该方法");
        
    }
    
}

- (UIView *)placeholderView {
    
    if (_placeholderView) {
        
        return _placeholderView;
    } else {
        
        ;
        NSLog(@"请先调用%@ 进行初始化",NSStringFromSelector(@selector(placholderViewWithTitle:opTitle:)));
        
        return nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@类内存大爆炸",[self class]);
}

@end