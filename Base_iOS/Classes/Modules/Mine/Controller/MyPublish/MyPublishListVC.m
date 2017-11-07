//
//  MyPublishListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyPublishListVC.h"

#import "GoodModel.h"

#import "MyPublishTableView.h"

#import "GoodDetailVC.h"
#import "EditGoodVC.h"
#import "PublishVC.h"
#import "NavigationController.h"
#import "TabbarViewController.h"

@interface MyPublishListVC ()

@property (nonatomic, strong) MyPublishTableView *tableView;

@property (nonatomic,strong) TLPageDataHelper *pageDataHelper;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;

@property (nonatomic, assign) BOOL isFirst;
//暂无我发布的
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation MyPublishListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initPlaceHolderView];
    //商品
    [self initTableView];
    //获取商品列表
    [self requesGoodList];
    
    [self.tableView beginRefreshing];
    //刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];
}

#pragma mark - Init
- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[MyPublishTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight) style:UITableViewStyleGrouped];
    
    self.tableView.placeHolderView = self.placeHolderView;

    self.tableView.publishBlock = ^(PublishType publishType, GoodModel *good, NSInteger section) {
        
        [weakSelf publishEventsWithType:publishType good:good section:section];
        
    };
    
    [self.view addSubview:self.tableView];
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无发布的宝贝");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    NSString *promptStr = _status == GoodStatusPublished ? @"还没有发布宝贝哦": @"还没有下架的宝贝哦";

    UILabel *textLbl = [UILabel labelWithText:promptStr textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    
    if (_status == GoodStatusPublished) {
        
        UIButton *publishBtn = [UIButton buttonWithTitle:@"去发布" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
        
        publishBtn.frame = CGRectMake(0, textLbl.yy + 30, 100, 35);
        publishBtn.centerX = kScreenWidth/2.0;
        
        [publishBtn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
        [self.placeHolderView addSubview:publishBtn];
    }

}

#pragma mark - Notification
- (void)refreshData {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events
- (void)publishEventsWithType:(PublishType)type good:(GoodModel *)good section:(NSInteger)section {
    
    switch (type) {
        case PublishTypeClickCell:
        {
            GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
            
            detailVC.code = good.code;
            detailVC.userId = good.storeCode;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }break;
           
        case PublishTypeEdit:
        {
            EditGoodVC *editGoodVC = [EditGoodVC new];
            
            editGoodVC.good = good;
            
            [self.navigationController pushViewController:editGoodVC animated:YES];
            
        }break;
            
        case PublishTypeOff:
        {
            //下架产品
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"808014";
            
            http.parameters[@"code"] = good.code;
            http.parameters[@"updater"] = [TLUser user].userId;
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"下架成功"];
                
                [self.tableView beginRefreshing];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];

            } failure:^(NSError *error) {
                
            }];
            
        }break;
            
        case PublishTypeOn:
        {
            //上架产品
            TLNetworking *http = [TLNetworking new];
            
            http.code = @"808013";
            
            http.parameters[@"code"] = good.code;
            http.parameters[@"updater"] = [TLUser user].userId;
            http.parameters[@"location"] = @"0";
            http.parameters[@"orderNo"] = @"0";
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"上架成功"];
                
                [self.tableView beginRefreshing];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];

            } failure:^(NSError *error) {
                
            }];
        }break;
            
        case PublishTypeDelete:
        {
            
            [TLAlert alertWithTitle:@"" msg:@"确定删除该商品吗" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.showView = self.view;
                
                http.code = @"808011";
                http.parameters[@"code"] = good.code;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"删除成功"];
                    
                    [self.goods removeObjectAtIndex:section];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                    
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    
                    if (self.tableView.goods.count == 0) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
//                            self.tableView.placeHolderView = self.placeHolderView;

                            [self.tableView reloadData_tl];
                            
                        });
                        
                    } else {
                        
//                        self.tableView.placeHolderView = nil;

                    }
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
            }];
 
        }break;
            
        default:
            break;
    }
}

- (void)publish:(UIButton *)sender {
    
    BaseWeakSelf;
    
    PublishVC *publishVC = [PublishVC new];
    
    publishVC.publishSuccess = ^{
        
        [weakSelf.tableView beginRefreshing];

    };
    
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:publishVC];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

#pragma mark - Data
- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808021";
    
    if (self.status == GoodStatusPublished) {
        
        helper.parameters[@"statusList"] = @[@"3"];

    } else if (self.status == GoodStatusPublishOff) {
        
        helper.parameters[@"statusList"] = @[@"4", @"5", @"6"];

    }
    
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    //    helper.parameters[@"kind"] = @"1";
    //    helper.parameters[@"location"] = @"1";
    
    
    helper.tableView = self.tableView;
    [helper modelClass:[GoodModel class]];
    
    self.pageDataHelper = helper;
    
    [self.tableView addRefreshAction:^{
        
        //店铺数据
        [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            weakSelf.tableView.goods = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            
            weakSelf.tableView.goods = objs;

            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    //--//
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
