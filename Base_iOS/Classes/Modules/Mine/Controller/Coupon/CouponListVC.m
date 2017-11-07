//
//  CouponListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponListVC.h"
#import "TLTableView.h"
#import "MineCouponCell.h"

@interface CouponListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <CouponModel *>*coupons;

@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UILabel *promptLbl;

@end

@implementation CouponListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initPlaceHolderView];
    
    [self initTableView];
    
    [self requestCouponList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.rowHeight = 100;
    
    [self.view addSubview:self.tableView];
    
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无优惠券");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"暂无优惠券" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    
}

#pragma mark - Data
- (void)requestCouponList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"801118";
    helper.showView = self.view;
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    //用户ID
    helper.parameters[@"toUser"] = [TLUser user].userId;
    //降序
    helper.parameters[@"orderDir"] = @"desc";
    //按金额排序
    helper.parameters[@"orderColumn"] = @"par_value";
    
    if (self.statusType == CouponStatusTypeUse) {
        
        helper.parameters[@"status"] = @"0";

    } else if (self.statusType == CouponStatusTypeUnUse) {
        
        helper.parameters[@"status"] = @"1";

    } else {
        
        helper.parameters[@"status"] = @"3";

    }
    
    [helper modelClass:[CouponModel class]];
    
    helper.tableView = self.tableView;
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.coupons = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.coupons = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.coupons.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *mineCouponCellID = @"MineCouponCellID";
    
    MineCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCouponCellID];
    
    if (!cell) {
        
        cell = [[MineCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineCouponCellID];
        
    }
    
    cell.coupon = self.coupons[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_couponBlock) {
        
        CouponModel *coupon = self.coupons[indexPath.row];
        
        _couponBlock(coupon);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
