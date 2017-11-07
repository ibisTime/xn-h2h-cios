//
//  ZHGoodsDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/26.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHGoodsDetailVC.h"

#import "TLBannerView.h"
#import "ZHStepView.h"
#import "ZHTreasureInfoView.h"
#import "ShareView.h"
#import "CDGoodsParameterChooseView.h"
#import "BaseDetailWebView.h"

#import "ZHImmediateBuyVC.h"
#import "ZHEvaluateListVC.h" //评价列表
#import "ZHSingleDetailVC.h" //详情列表
#import "ZHShoppingCartVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"

#import "MJRefresh.h"
#import "AppConfig.h"
#import "CDGoodsParameterModel.h"

@interface ZHGoodsDetailVC ()<GoodsParameterChooseDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic,weak) TLBannerView *bannerView;
@property (nonatomic, strong) UIScrollView *goodsDetailTypeScrollView;

@property (nonatomic,strong) UILabel *nameLbl;          //商品名称
@property (nonatomic,strong) UILabel *advLbl;           //广告语
@property (nonatomic,strong) UILabel *priceLbl;         //商品价格
@property (nonatomic, strong) UILabel *marketPriceLbl;  //市场参考价

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;

//
@property (nonatomic,strong) UIView *switchView;
@property (nonatomic, strong) UIView *switchSubView;
@property (nonatomic, assign) BOOL switchByTap;

//顶部切换相关
@property (nonatomic, strong) UIView *switchLine;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *evaluateViwe;

@property (nonatomic, copy) NSArray <CDGoodsParameterModel *> *parameterModelArr;

@end


@implementation ZHGoodsDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bannerView.timer invalidate];
    self.bannerView.timer = nil;
}

- (void)tl_placeholderOperation {
    
    //先查询规格
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808037";
    http.parameters[@"productCode"] = self.goods.code;
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        
        self.parameterModelArr = [CDGoodsParameterModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self setUpUI];
        [self addEvent];
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

    }];
    //
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
  
}

- (void)addEvent {


    //
    self.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    //拍普通商品，价格在上面
    
    NSArray *imgUrls = [self.goods.pic componentsSeparatedByString:@"||"];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSString *url in imgUrls) {
        
        [images addObject:[url convertImageUrl]];
        
    }
    
    self.bannerView.imgUrls = images.copy;
    
    CDGoodsParameterModel *model = self.goods.productSpecsList[0];
    
    //---//
    self.nameLbl.text = self.goods.name;
    self.advLbl.text = self.goods.slogan;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [[model.price1 stringValue] convertToRealMoney]];
    self.marketPriceLbl.text = [NSString stringWithFormat:@"市场参考价: ￥%@", [[model.originalPrice stringValue] convertToRealMoney]];
    
//    self.postageLbl.text = @"邮费:10元";
    
    //扩大
//    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth, self.stepView.yy + 10);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treasureSuccess) name:@"dbBuySuccess" object:nil];
    
}

#pragma mark- 顶部切换事件
- (void)switchConten:(UIButton *)btn {
    
    
    if ([_lastBtn isEqual:btn]) {
        
        return;
    }
    
    self.switchByTap = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.switchByTap = NO;
        
    });
    
    NSInteger tag = btn.tag - 100;
    
    switch (tag) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
            
            //参数
//        case 2:
//            
//            [self.goodsDetailTypeScrollView addSubview:self.goodsArgsView];
//            
//            break;
//            
//            //评价
//        case 2 :
//            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
//            
//            break;
            
            
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;
    
    
    //
    [self.goodsDetailTypeScrollView setContentOffset:CGPointMake(self.goodsDetailTypeScrollView.width*tag, 0) animated:YES];
    
}

#pragma mark- 商品详情切换的scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    if (self.switchByTap) {
      
        return;
    }
    
    NSInteger tag =  scrollView.contentOffset.x/kScreenWidth + 100;
    
    if (tag < 0) {
        return;
    }

    UIButton *btn = (UIButton *)[self.switchSubView viewWithTag:tag];
    
    if (!btn) {
        return;
    }
    
    switch (tag - 100) {
            //商品
        case 0: [self.goodsDetailTypeScrollView addSubview:self.bgScrollView];
            
            break;
            //详情
        case 1:  [self.goodsDetailTypeScrollView addSubview:self.detailView];
            
            break;
            
            //评价
//        case 2 :
//            [self.goodsDetailTypeScrollView addSubview:self.evaluateViwe];
//            
//            break;
            
    }
    
    if (!btn || [self.lastBtn isEqual:btn]) {
        return;
    }
    
    //
    [UIView animateWithDuration:0.25 animations:^{
        
        self.switchLine.centerX = btn.centerX;
        btn.titleLabel.font = FONT(18);
        [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
        [self.lastBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.lastBtn.titleLabel.font = FONT(17);
    }];
    
    self.lastBtn = btn;
    

}


-(void)share {
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
    }];
    
    shareView.shareTitle = @"健康e购";
//    shareView.shareDesc = self.shop.name;
//    shareView.shareURL = [NSString stringWithFormat:@"%@/share/store.html?code=%@",[AppConfig config].shareBaseUrl,self.shop.code];
    
    NSString *shareImgStr = nil;
    
    shareView.shareImgStr = shareImgStr;
    
    [self.view addSubview:shareView];
    
    
    
}


- (void)treasureSuccess {

    [self.bgScrollView.mj_header beginRefreshing];
}

//- (void)cartCountChange {
//
//    if (self.detailType == ZHGoodsDetailTypeDefault && self.buyView) {
//        
//        self.buyView.countView.msgCount = [ZHCartManager manager].count;
//        
//    }
//    //----//
//}


#pragma mark- 一元夺宝刷新
- (void)refresh {

      [self.bgScrollView.mj_header endRefreshing];
}

#pragma mark- 规格选择的代理
- (void)finishChooseWithType:(GoodsParameterChooseType)type btnType:(GoodsBtnType)btnType chooseView:(CDGoodsParameterChooseView *)chooseView parameter:(CDGoodsParameterModel *)parameterModel count:(NSInteger)count {

    [chooseView dismiss];
    
    if (!parameterModel) {
        
        [TLAlert alertWithInfo:@"请传递规格"];
        return;
    }
    
    if (btnType == GoodsBtnTypeBuy) {
        
        //
        ZHImmediateBuyVC *buyVC = [[ZHImmediateBuyVC alloc] init];
        buyVC.type = ZHIMBuyTypeSingle;
        buyVC.postage = @0;
        
        self.goods.currentCount = count;
        self.goods.currentParameterPriceRMB = parameterModel.price1;
        self.goods.currentParameterPriceGWB = parameterModel.price2;
        self.goods.currentParameterPriceQBB = parameterModel.price3;
        self.goods.selectedParameter = parameterModel;
        
        buyVC.goodsRoom = @[self.goods];
        [self.navigationController pushViewController:buyVC animated:YES];
        
    } else if (btnType == GoodsBtnTypeAddToCart) {
    
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808040";
        http.parameters[@"userId"] = [TLUser user].userId;
//        http.parameters[@"token"] = [TLUser user].token;
        
        http.parameters[@"productSpecsCode"] = parameterModel.code;
        http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",chooseView.stepView.count];
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"添加到购物车成功"];
            
            //        [ZHCartManager manager].count = [ZHCartManager manager].count + self.stepView.count;
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    
}

#pragma mark - Events

- (void)clickShoppingCart {
    
    ZHShoppingCartVC *shoppingCartVC = [ZHShoppingCartVC new];
    
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark- 购买
- (void)buy {
    
    //
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            
            [weakSelf buy];
        };
        return;
    }
    
    CDGoodsParameterChooseView *chooseView = [CDGoodsParameterChooseView chooseView];
    chooseView.coverImageUrl = [self.goods.advPic convertImageUrl];
    chooseView.btnType = GoodsBtnTypeBuy;
    
    [chooseView loadArr:self.parameterModelArr];
    chooseView.delegate = self;
    [chooseView show];
    
}


#pragma mark- 加入购物车
- (void)addToShopCar {

    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            
            [weakSelf buy];
        };
        return;
    }
    
    CDGoodsParameterChooseView *chooseView = [CDGoodsParameterChooseView chooseView];
    chooseView.coverImageUrl = [self.goods.advPic convertImageUrl];
    chooseView.btnType = GoodsBtnTypeAddToCart;
    
    [chooseView loadArr:self.parameterModelArr];
    chooseView.delegate = self;
    [chooseView show];

}

#pragma mark- 购物车
- (void)openShopCar {

    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
            
            ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return;
    }
    
    ZHShoppingCartVC *vc = [[ZHShoppingCartVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

}



- (UIView *)detailView {
    
    if (!_detailView) {
        
//        BaseWeakSelf;
        
        BaseDetailWebView *wkWebView = [[BaseDetailWebView alloc] initWithFrame:CGRectOffset(self.bgScrollView.frame, kScreenWidth, 0)];

        [wkWebView loadWebWithString:_goods.desc];
        
        _detailView = wkWebView;
    }
    
    return _detailView;
    
}

-(UIView *)evaluateViwe {
    
    if (!_evaluateViwe) {
        
        ZHEvaluateListVC *evaluateListVC = [[ZHEvaluateListVC alloc] init];
        
        evaluateListVC.goodsCode = self.goods.code;
        evaluateListVC.peopleNum = self.goods.boughtCount;
        evaluateListVC.view.frame = CGRectOffset(self.bgScrollView.frame, kScreenWidth*2, 0);
        [self addChildViewController:evaluateListVC];
        [self.view addSubview:evaluateListVC.view];

        _evaluateViwe = evaluateListVC.view;
        
    }
    
    return _evaluateViwe;
    
}

- (void)setUpUI {

    self.navigationItem.titleView = self.switchView;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    [UIBarButtonItem addRightItemWithImageName:@"购物车" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(openShopCar)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //底部负责左右切换的背景
    self.goodsDetailTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight)];
    [self.view addSubview:self.goodsDetailTypeScrollView];
    self.goodsDetailTypeScrollView.pagingEnabled = YES;
    self.goodsDetailTypeScrollView.showsHorizontalScrollIndicator = NO;
    self.goodsDetailTypeScrollView.backgroundColor = [UIColor zh_backgroundColor];
    self.goodsDetailTypeScrollView.delegate = self;
    self.goodsDetailTypeScrollView.contentSize = CGSizeMake(self.goodsDetailTypeScrollView.width*2, self.goodsDetailTypeScrollView.height);
    
    //商品信息背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.goodsDetailTypeScrollView addSubview: self.bgScrollView];
    
    CGFloat w = kScreenWidth/2.0;
    
    UIButton *addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgScrollView.yy, w, 49) title:@"加入购物车" backgroundColor:kOrangeRedColor];
    
    [addCartBtn addTarget:self action:@selector(addToShopCar) forControlEvents:UIControlEventTouchUpInside];
    addCartBtn.titleLabel.font = FONT(18);
    [self.view addSubview:addCartBtn];
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(w, self.bgScrollView.yy, w, 49) title:@"立即购买" backgroundColor:[UIColor zh_themeColor]];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = FONT(18);
    [self.view addSubview:buyBtn];
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.8)];
    [self.bgScrollView addSubview:bannerView];
    self.bannerView = bannerView;
    
    
    //
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(1));
    }];
    
    //名字
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(16)
                                 textColor:[UIColor zh_textColor]];
    self.nameLbl.numberOfLines = 0;
    [self.bgScrollView addSubview:self.nameLbl];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.top.equalTo(self.bannerView.mas_bottom).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));

    }];
    

    //广告语
//    CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, 10)
    self.advLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
    [self.bgScrollView addSubview:self.advLbl];
    self.advLbl.numberOfLines = 0;
    [self.advLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));
    }];

    //价格
//    CGRectMake(self.nameLbl.x, self.advLbl.yy + 11, self.nameLbl.width, 10)
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(16)
                                  textColor:[UIColor zh_themeColor]];
    [self.bgScrollView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));
    }];
    
    //市场参考价
    self.marketPriceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(13)
                                  textColor:[UIColor zh_textColor]];
    [self.bgScrollView addSubview:self.marketPriceLbl];
    [self.marketPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left).offset(15);
        make.width.mas_equalTo(@(kScreenWidth - 30));
    }];
    
    //
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = [UIColor zh_lineColor];
    [self.bgScrollView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.marketPriceLbl.mas_bottom).offset(11);
        make.left.equalTo(self.bgScrollView.mas_left);
        make.width.mas_equalTo(@(kScreenWidth));
        make.height.mas_equalTo(@(1));
        
    }];
   
   //
 
}

#pragma mark- 顶部切换UI
- (UIView *)switchView {
    
    if (!_switchView) {
        
        _switchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 160, 34)];
        _switchView.backgroundColor = kClearColor;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _switchView.width, 40)];
        self.switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 2, 40, 2)];
        self.switchLine.backgroundColor = [UIColor zh_themeColor];
        [bgView addSubview:self.switchLine];
        self.switchSubView = bgView;
        
        NSArray *types = @[@"商品",@"详情"];
        for (NSInteger i = 0; i < types.count; i ++) {
            
            CGFloat x = _switchView.width/types.count;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*x, 2, x, 28) title:types[i] backgroundColor:kClearColor];
            btn.titleLabel.font = FONT(17);
            [bgView addSubview:btn];
            
            [btn addTarget:self action:@selector(switchConten:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            
            btn.tag = i + 100;
            
            if (i == 0) {
                btn.titleLabel.font = FONT(18);
                self.switchLine.centerX = btn.centerX;
                [btn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
                self.lastBtn = btn;
            }
            
        }
        
        [_switchView addSubview:bgView];
    }
    return _switchView;
    
}


@end
