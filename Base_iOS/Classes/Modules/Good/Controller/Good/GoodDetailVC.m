//
//  GoodDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodDetailVC.h"

#import "GoodDetailHeaderView.h"
#import "GoodDetailContentCell.h"
#import "GoodDetailCommentCell.h"

#import "GoodModel.h"
#import "CommentModel.h"
#import "GoodDetailLayoutItem.h"
#import "CommentLayoutItem.h"
#import "FilterManager.h"

#import "SendCommentVC.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "ImmediateBuyVC.h"
#import "ZHNewPayVC.h"
#import "HomePageVC.h"
#import "ShareView.h"

@interface GoodDetailVC ()<UITableViewDelegate, UITableViewDataSource, GoodDetailCellDelegate>
//收藏
@property (nonatomic, strong) UIButton *collectBtn;
//头部
@property (nonatomic, strong) GoodDetailHeaderView *headerView;
//底部
@property (nonatomic, strong) UIView *bottomView;
//合计价格
@property (nonatomic, strong) UILabel *amountLbl;
//折扣
@property (nonatomic, strong) UILabel *promptLbl;
//tableView
@property (nonatomic, strong) TLTableView *tableView;
//placeHolderView
@property (nonatomic, strong) UIView *placeHolderView;
//普通商品的模型
@property (nonatomic,strong) GoodModel *good;
//用户信息
@property (nonatomic, strong) TLUser *currentUser;
//
@property (nonatomic, strong) GoodDetailLayoutItem *layoutItem;

@property (nonatomic, strong) NSMutableArray <CommentLayoutItem *> *commentLayoutItems;
//评论页数
@property (nonatomic, assign) NSInteger commentPageStart;

@property (nonatomic, assign) BOOL isFirst;
//分享
@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation GoodDetailVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.commentPageStart = 2;
    
    //获取产品详情
    [self requestGoodDetail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    
    _isFirst = YES;
    
    self.commentLayoutItems = [[NSMutableArray alloc] init];
    
    [self addRightItem];
    
    //用户浏览详情
    if ([TLUser user].userId) {
        
        [self userReadGoodDetail];
        
    }
    
    //
    if ([self.userId isEqualToString:[TLUser user].userId]) {
        
        [self getShareUrl];
    }
    
    //刷新评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentList) name:@"RefreshCommentList" object:nil];
    
    
}

#pragma mark - Init
- (void)addRightItem {
    
    UIButton *collectBtn = [UIButton buttonWithImageName:@"想要" selectedImageName:@"想要-点击"];
    
    [collectBtn setImage:kImage(@"想要-点击") forState:UIControlStateHighlighted];
    
    collectBtn.frame = CGRectMake(0, 0, 16, 15);
    [collectBtn setEnlargeEdge:10];
    
    [collectBtn addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    
    self.collectBtn = collectBtn;
    
}

#pragma mark - 懒加载

//顶部视图
- (GoodDetailHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[GoodDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        
        _headerView.backgroundColor = kWhiteColor;
        
    }
    return _headerView;
    
}

//底部视图
- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        CGFloat viewH = 50 + kBottomInsetHeight;
        
        CGFloat btnW = kScreenWidth == 320 ? kWidth(110): 110;
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - viewH, kScreenWidth, viewH)];
        
        _bottomView.backgroundColor = kWhiteColor;
        
        [self.view addSubview:_bottomView];
        
        //合计
        _amountLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:14.0];
        
        [_bottomView addSubview:_amountLbl];
        [_amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.centerY.equalTo(@(- kBottomInsetHeight/2.0));
            
        }];
        
        if ([FilterManager manager].isCoupon) {
            
            self.promptLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
            
            [_bottomView addSubview:self.promptLbl];
            
        }
        
        if (![self.userId isEqualToString:[TLUser user].userId]) {
            
            //马上买
            UIButton *buyBtn = [UIButton buttonWithTitle:@"马上买" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:15.0 cornerRadius:5];
            
            [buyBtn addTarget:self action:@selector(buyGood) forControlEvents:UIControlEventTouchUpInside];
            
            [_bottomView addSubview:buyBtn];
            [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(viewH - 12);
                make.width.mas_equalTo(btnW);
                make.centerY.mas_equalTo(- kBottomInsetHeight/2.0);
                
            }];
            
            //联系卖家
            UIButton *linkSellerBtn = [UIButton buttonWithTitle:@"联系卖家" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
            
            [linkSellerBtn addTarget:self action:@selector(linkSeller) forControlEvents:UIControlEventTouchUpInside];
            
            [_bottomView addSubview:linkSellerBtn];
            
            [linkSellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(buyBtn.mas_left).mas_equalTo(-10);
                make.height.mas_equalTo(viewH - 12);
                make.width.mas_equalTo(btnW);
                make.centerY.mas_equalTo(- kBottomInsetHeight/2.0);
                
            }];
            
        } else {
            
            //分享宝贝
            UIButton *shareBtn = [UIButton buttonWithTitle:@"分享宝贝" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:15.0 cornerRadius:5];
            
            [shareBtn addTarget:self action:@selector(shareGood) forControlEvents:UIControlEventTouchUpInside];
            
            [_bottomView addSubview:shareBtn];
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(@(-15));
                make.height.equalTo(@(viewH - 12));
                make.left.equalTo(_amountLbl.mas_right).offset(10);
                make.centerY.equalTo(@(- kBottomInsetHeight/2.0));
                
            }];
        }
        
    }
    
    return _bottomView;
}

- (TLTableView *)tableView {
    
    if (!_tableView) {
        
//        CGFloat tableViewHeight = ![self.userId isEqualToString:[TLUser user].userId] ? kSuperViewHeight - 50 - kBottomInsetHeight: kSuperViewHeight - kBottomInsetHeight;
        CGFloat tableViewHeight = kSuperViewHeight - 50 - kBottomInsetHeight;

        _tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, tableViewHeight) delegate:self dataSource:self];
        
        [_tableView registerClass:[GoodDetailContentCell class] forCellReuseIdentifier:@"GoodDetailContentCellId"];
        
        [_tableView registerClass:[GoodDetailCommentCell class] forCellReuseIdentifier:@"GoodDetailCommentCellId"];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)placeHolderView {
    
    if (!_placeHolderView) {
        
        _placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        
        _placeHolderView.backgroundColor = kWhiteColor;
        
        //暂无互动
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 118, 99)];
        
        imageView.image = kImage(@"暂无互动");
        
        imageView.centerX = _placeHolderView.centerX;
        
        [_placeHolderView addSubview:imageView];
        //
        UILabel *textLbl = [UILabel labelWithFrame:CGRectMake(0, imageView.yy + 15, kScreenWidth, kFontHeight(14.0)) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(14.0) textColor:kTextColor2];
        
        [_placeHolderView addSubview:textLbl];
        
        //留言
        UIButton *commentBtn = [UIButton buttonWithTitle:@"我要留言" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15 cornerRadius:5];
        
        commentBtn.frame = CGRectMake(0, textLbl.yy + 18, 105, 37);
        
        commentBtn.centerX = _placeHolderView.centerX;
        
        [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
        
        [_placeHolderView addSubview:commentBtn];
        
        _tableView.placeHolderView = _placeHolderView;
    }
    
    return _placeHolderView;
}

- (GoodDetailLayoutItem *)layoutItem {
    
    if (!_layoutItem) {
        
        _layoutItem = [[GoodDetailLayoutItem alloc] init];
        
    }
    
    return _layoutItem;
}

#pragma mark - Data
- (void)requestGoodDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808026";
    
    if (_isFirst) {
        
        http.showView = self.view;
    }
    
    http.parameters[@"code"] = self.code;
    
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        _isFirst = NO;
        
        self.good = [GoodModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //收藏
        self.collectBtn.selected = [self.good.isCollect isEqualToString:@"0"] ? NO: YES;
        
        //加载TableView
        self.tableView.tableHeaderView = self.headerView;
        //
        self.layoutItem.good = self.good;
        //加载头部
        self.headerView.good = self.good;
        //加载底部
        self.bottomView.hidden = NO;
        //计算商品金额
        [self calculationGoodAmount];
        //获取用户信息
        [self getUserInfo];
        //获取浏览量
        [self requestReadNumber];
        //获取用户评论
        [self requestUserComment];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)calculationGoodAmount {
    
    //
    CGFloat amount = [_good.price doubleValue]*[_good.discount doubleValue] + [_good.yunfei doubleValue];
    
    NSString *amountStr = [@(amount) convertToSimpleRealMoney];
    
    NSString *text = [NSString stringWithFormat:@"金额: ￥%@", amountStr];
    
    [self.amountLbl labelWithString:text title:[NSString stringWithFormat:@"￥%@", amountStr] font:Font(18.0) color:kThemeColor];
    
    if ([FilterManager manager].isCoupon && [self.good.activityType isEqualToString:@"1"]) {
        
        [self.amountLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(@(-kBottomInsetHeight/2.0 - 10));
            
        }];
        
        self.promptLbl.text = [NSString stringWithFormat:@"已享受%lg折优惠", [_good.discount doubleValue]*10];
        
        [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_amountLbl.mas_left);
            make.centerY.equalTo(@(-kBottomInsetHeight/2.0 + 10));
            make.width.lessThanOrEqualTo(@150);
            
        }];
    }
}
- (void)getUserInfo {
    
    //1.根据userId 获取用户信息
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805256";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.currentUser = [TLUser mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)requestReadNumber {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801037";
    
    http.parameters[@"category"] = @"P";
    http.parameters[@"type"] = @"3";
    http.parameters[@"entityCode"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.headerView.readLbl.text = [NSString stringWithFormat:@"浏览%@", responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)userReadGoodDetail {
    
    //浏览
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801030";
    http.isShowMsg = NO;
    
    http.parameters[@"category"] = @"P";
    http.parameters[@"type"] = @"3";
    http.parameters[@"entityCode"] = self.code;
    http.parameters[@"interacter"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestUserComment {
    
    BaseWeakSelf;
    
    //获取评论
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"801025";
    
    helper.parameters[@"entityCode"] = self.code;
    helper.parameters[@"interacter"] = [TLUser user].userId;
    helper.parameters[@"orderColumn"] = @"comment_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"status"] = @"AB";
    helper.parameters[@"start"] = [NSString stringWithFormat:@"%ld",self.commentPageStart];
    helper.parameters[@"limit"] = @"10";
    
    helper.tableView = self.tableView;
    [helper modelClass:[CommentModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.commentLayoutItems = [NSMutableArray array];
        
        [objs enumerateObjectsUsingBlock:^(CommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CommentLayoutItem *layoutItem = [CommentLayoutItem new];
            
            layoutItem.commentModel = obj;
            
            [weakSelf.commentLayoutItems addObject:layoutItem];
            
        }];
        
        if (self.commentLayoutItems.count) {
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (!objs.count) {//
                
                [weakSelf.tableView endRefreshingWithNoMoreData_tl];
                
            } else {
                
                weakSelf.commentLayoutItems = [NSMutableArray array];

                [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    CommentLayoutItem *layoutItem = [CommentLayoutItem new];
                    layoutItem.commentModel = obj;
                    //
                    [weakSelf.commentLayoutItems addObject:layoutItem];
                    
                }];
                
                weakSelf.commentPageStart ++;
                [weakSelf.tableView reloadData_tl];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)userCollect {
    
    //用户收藏商品
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801030";
    http.isShowMsg = NO;
    
    http.parameters[@"category"] = @"P";
    http.parameters[@"type"] = @"1";
    http.parameters[@"entityCode"] = self.code;
    http.parameters[@"interacter"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.collectBtn.selected = YES;
        //刷新我想要的列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WantRefreshData" object:nil];
        //刷新圈子列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircleData" object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)userCancelCollect {
    
    //用户取消收藏
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801031";
    http.isShowMsg = NO;
    
    http.parameters[@"category"] = @"P";
    http.parameters[@"type"] = @"1";
    http.parameters[@"entityCode"] = self.code;
    http.parameters[@"interacter"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.collectBtn.selected = NO;
        //刷新我想要的列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WantRefreshData" object:nil];
        //刷新圈子列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCircleData" object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}
//是否收藏
- (void)getCollectionRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808026";
    
    http.parameters[@"code"] = self.code;
    
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.good = [GoodModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //收藏
        self.collectBtn.selected = [self.good.isCollect isEqualToString:@"0"] ? NO: YES;
        
        if (self.collectBtn.selected == YES) {
            
            return ;
            
        } else {
            
            [self userCollect];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getShareUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808917";
    http.parameters[@"key"] = @"product_recommend";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.shareUrl = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Notification
- (void)refreshCommentList {
    
    [self requestUserComment];
}

#pragma mark - Events

- (void)buyGood {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf buyGood];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    ImmediateBuyVC *buyVC = [[ImmediateBuyVC alloc] init];
    
    buyVC.type = IMBuyTypeSingle;
    buyVC.postage = _good.yunfei;
    
    buyVC.good = self.good;
    [self.navigationController pushViewController:buyVC animated:YES];
    
}

- (void)linkSeller {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf linkSeller];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    IMAUser *user = [[IMAUser alloc] initWith:self.userId];
    
    user.nickName = _good.nickName;
    user.icon = [_good.photo convertImageUrl];
    user.remark = _good.nickName;
    user.userId = self.userId;
    
    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    
    userInfo.minePhoto = [TLUser user].photo;
    userInfo.friendPhoto = _good.photo;
    userInfo.friendNickName = _good.nickName;
    
    ChatViewController *chatVC = [[CustomChatUIViewController alloc] initWith:user];
    
    chatVC.userInfo = userInfo;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)shareGood {
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
        
    }];
    
    shareView.shareTitle = @"邀请好友";
    shareView.shareDesc = @"邀好友送优惠券 多邀多得";
    shareView.shareURL = [NSString stringWithFormat:@"%@%@", self.shareUrl, self.good.code];
    
    [self.view addSubview:shareView];
}

- (void)clickComment {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf clickComment];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    //对宝贝进行留言
    SendCommentVC *sendCommentVC = [[SendCommentVC alloc] init];
    sendCommentVC.type =  SendCommentActionTypeLeaveMessage;
    sendCommentVC.toObjCode = self.layoutItem.good.code;
    sendCommentVC.titleStr = @"留言";
    //
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:sendCommentVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickCollect:(UIButton *)sender {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf getCollectionRelation];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    BOOL isCollect = !sender.selected;
    
    if (isCollect) {
        
        [self userCollect];
        
    } else {
        
        [self userCancelCollect];
    }
}

#pragma mark - GoodDetailContentCellDelegate

- (void)didSelectActionWithType:(GoodDetailEventsType)type index:(NSInteger)index {
    
    //    LayoutItem *layoutItem = self.timeLineLayoutItemRoom[index];
    //
    //    NSString *articleCode = layoutItem.article.code;
    
    switch (type) {
        case GoodDetailEventsTypeHeadIcon:
        {
            HomePageVC *pageVC = [HomePageVC new];
            
            pageVC.userId = self.userId;
            
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
            
        case GoodDetailEventsTypeShowTitle:
            
        {
            [self.tableView reloadData_tl];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewSatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return section == 0 ? 1: self.commentLayoutItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *goodDetailContentCellId = @"GoodDetailContentCellId";
        GoodDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:goodDetailContentCellId forIndexPath:indexPath];
        
        cell.layoutItem = self.layoutItem;
        
        cell.delegate = self;
        
        cell.user = self.currentUser;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    static NSString *goodDetailCommentCellId = @"GoodDetailCommentCellId";
    
    CommentLayoutItem *commentLayoutItem = self.commentLayoutItems[indexPath.row];
    
    GoodDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:goodDetailCommentCellId forIndexPath:indexPath];
    
    cell.commentLayoutItem = commentLayoutItem;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return _layoutItem.cellHeight;
    }
    
    CommentLayoutItem *layoutItem = _commentLayoutItems[indexPath.row];
    
    return indexPath.section == 0 ? : layoutItem.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 10: 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kBackgroundColor;
    
    if (section == 1) {
        
        bgView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
        
        whiteView.backgroundColor = kWhiteColor;
        
        [bgView addSubview:whiteView];
        
        UILabel *interactLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        
        interactLabel.text = [NSString stringWithFormat:@"互动 (%ld)",_commentLayoutItems.count];
        
        [whiteView addSubview:interactLabel];
        [interactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(100);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //留言
        UIButton *commentBtn = [UIButton buttonWithTitle:@"我要留言" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15 cornerRadius:5];
        
        commentBtn.frame = CGRectMake(kScreenWidth - 105 - 15, 0, 105, 37);
        
        commentBtn.centerY = whiteView.height/2.0;
        
        [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
        
        [whiteView addSubview:commentBtn];
        //评论数大于0显示
        commentBtn.hidden = self.commentLayoutItems.count > 0 ? NO: YES;
        
    }
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat footerH = self.commentLayoutItems.count == 0 ? 230: 20;
    
    return section == 0 ? 0.1: footerH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    if (self.commentLayoutItems.count == 0) {
        
        [footerView addSubview:self.placeHolderView];
    }
    
    return footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
