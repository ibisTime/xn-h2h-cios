//
//  MySellListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MySellListVC.h"
#import "OrderModel.h"
#import "ExpressModel.h"

#import "OrderGoodsCell.h"
#import "SellFooterView.h"
#import "SendGoodAlertView.h"
#import "RefundMoneyAlertView.h"

#import "MySellOrderDetailVC.h"

@interface MySellListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;
//暂无订单
@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,assign) BOOL isFirst;
//发货
@property (nonatomic, strong) SendGoodAlertView *alertView;
//退款
@property (nonatomic, strong) RefundMoneyAlertView *refundAlertView;
//退款结果
@property (nonatomic, copy) NSString *refundResult;
//退款备注
@property (nonatomic, copy) NSString *remark;
//物流公司
@property (nonatomic, strong) NSArray <ExpressModel *>*expressArr;

@property (nonatomic, strong) OrderModel *order;

@end

@implementation MySellListVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.isFirst = YES;
    
    [self initPlaceHolderView];
    
    [self initTableView];
    //发货
    [self initSendGoodView];
    //退款
    [self initRefundMoneyView];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithText:@"暂无订单" textColor:kTextColor textFont:15];
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    tableView.rowHeight = 100;
    
    tableView.placeHolderView = self.placeHolderView;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    //1 待支付"，2 已支付，3 已发货，4 已收货，5 已评论，6 退款申请，7 退款失败，8 退款成功 ，91取消订单
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808065";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"orderColumn"] = @"apply_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.parameters[@"toUser"] = [TLUser user].userId;
    
    helper.isDeliverCompanyCode = NO;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[OrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)initSendGoodView {
    
    BaseWeakSelf;
    
    self.alertView = [[SendGoodAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    self.alertView.cancelBlock = ^{
        
        [weakSelf.alertView hide];
    };
    
    self.alertView.confirmBlock = ^(ExpressModel *expressModel, NSString *expressNum) {
        
        [weakSelf sendGoodWithExpressModel:expressModel expressNum:expressNum];
        
    };

}

- (void)initRefundMoneyView {
    
    BaseWeakSelf;
    
    self.refundAlertView = [[RefundMoneyAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    
    self.refundAlertView.confirmBlock = ^(NSString *result, NSString *remark) {
        
        weakSelf.refundResult = result;
        
        weakSelf.remark = remark;
        
        [weakSelf remarkRefund];
        
    };
    
}

- (void)cancel
{
    
    //取消订单
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"code"] = @"";
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Events
- (void)sellEventsWithType:(SellEventsType)type order:(OrderModel *)order {
    
    self.order = order;

    BaseWeakSelf;
    
    switch (type) {
        case SellEventsTypeCancel:
        {
            [TLAlert alertWithTitle:@"" msg:@"确定取消订单？" confirmMsg:@"取消" cancleMsg:@"不取消" placeHolder:@"请输入取消原因" maker:nil cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action, UITextField *textField) {
                
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"808053";
                http.parameters[@"code"] = order.code;
                http.parameters[@"userId"] = [TLUser user].userId;
                http.parameters[@"remark"] = textField.text;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"取消订单成功"];
                    
                    [self.tableView beginRefreshing];
                    
                } failure:^(NSError *error) {
                    
                    
                }];
            }];
            
        }break;
            
        case SellEventsTypeSendGood:
        {
            //获取物流公司
            [self requestExpressName];
            
            [self.alertView show];

        }break;
            
        case SellEventsTypeConfirmRefund:
        {
            [self.refundAlertView show];
            
        }break;
            
        case SellEventsTypeLookComment:
        {
//            order.logisticsCompany
            
            [self getUserComment:order.code];
            
        }break;
            
        default:
            break;
    }
}

- (void)sendGoodWithExpressModel:(ExpressModel *)expressModel expressNum:(NSString *)expressNum {
    
    if (!expressModel) {
        
        [TLAlert alertWithInfo:@"请选择物流公司"];
        return ;
    }
    
    if (expressNum.length == 0) {
        
        [TLAlert alertWithInfo:@"请填写物流单号"];
        return ;
    }
    
    NSString *date = [NSString stringFromDate:[NSString getLocalDate] formatter:@"yyyy-MM-dd HH:mm:ss"];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808054";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"deliverer"] = [TLUser user].userId;
    http.parameters[@"deliveryDatetime"] = date;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"logisticsCode"] = expressNum;
    http.parameters[@"logisticsCompany"] = expressModel.dkey;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"发货成功"];
        
        [self.alertView hide];
        
        [self.tableView beginRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)remarkRefund {
    
    if ([self.refundResult isEqualToString:@"1"]) {
        
        [self comfirmRefundMoney];
        
    } else {
        
        [self cancelRefundMoney];
    }
}

#pragma mark - Data
- (void)requestExpressName {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801907";
    http.parameters[@"parentKey"] = @"back_kd_company";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.expressArr = [ExpressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.alertView.expressArr = self.expressArr;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserComment:(NSString *)orderCode {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"801029";
    http.parameters[@"orderCode"] = orderCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *status = responseObject[@"data"][@"status"];
                            
        if ([status isEqualToString:@"A"] || [status isEqualToString:@"B"]) {
            
            NSString *commentStr = responseObject[@"data"][@"content"];
            
            [TLAlert alertWithTitle:@"用户评价" message:commentStr confirmMsg:@"确定" confirmAction:^{
                
                
            }];
            
        } else {
            
            [TLAlert alertWithInfo:@"该评论存在敏感词，平台审核中"];
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)comfirmRefundMoney {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808062";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"result"] = self.refundResult;
    if (self.remark) {
        
        http.parameters[@"remark"] = self.remark;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"处理退款信息成功"];
        
        [self.refundAlertView hide];
        
        [self.tableView beginRefreshing];

    } failure:^(NSError *error) {
        
    }];
}
//拒绝退款
- (void)cancelRefundMoney {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808062";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"result"] = self.refundResult;
    
    if (self.remark) {
        
        http.parameters[@"remark"] = self.remark;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"处理退款信息成功"];
        
        [self.refundAlertView hide];

        [self.tableView beginRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MySellOrderDetailVC *vc = [[MySellOrderDetailVC alloc] init];
    vc.order = self.orderGroups[indexPath.section];
    
    //取消订单
    vc.cancleSuccess = ^(){
        
        [weakSelf.tableView beginRefreshing];
    };
    //发货
    vc.sendGoodSuccess = ^{
        
        [weakSelf.tableView beginRefreshing];
        
    };
    //确认退款
    vc.confirmRefundSuccess = ^(){
        
        [weakSelf.tableView beginRefreshing];
        
    };
    //查看评价
    vc.lookCommentSuccess = ^{
        
        [weakSelf.tableView beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrderNum:model.code date:model.applyDatetime];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"ZHOrderFooterViewId";
    
    SellFooterView *footerView = [[SellFooterView alloc] initWithReuseIdentifier:footerId];
    
    OrderModel *order = self.orderGroups[section];
    
    footerView.sellBlock = ^(SellEventsType type) {
        
        [weakSelf sellEventsWithType:type order:order];
        
    };
    
    footerView.order = self.orderGroups[section];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 98;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
    
}

#pragma mark- datasourece

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderGroups.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSArray *arr = self.orderGroups[section].productOrderList;
    //    return arr.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *OrderGoodsCellId = @"OrderGoodsCell";
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderGoodsCellId];
    if (!cell) {
        
        cell = [[OrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderGoodsCellId];
        
    }
    
    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}


- (UIView *)headerViewWithOrderNum:(NSString *)num date:(NSString *)date {
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    
    headerV.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];
    [headerV addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(15);
        make.top.equalTo(headerV.mas_top).offset(10);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"订单编号: %@", num];
    
    //
    UILabel *lbl2 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(11)
                                  textColor:[UIColor zh_textColor2]];;
    [headerV addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl1.mas_right).offset(-15);
        make.top.equalTo(lbl1.mas_top);
        make.bottom.equalTo(headerV.mas_bottom);
        make.right.equalTo(headerV.mas_right).offset(-15);
    }];
    lbl2.text = [date convertDate];
    
    //
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerV.height - 0.7, kScreenWidth, 0.7)];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerV addSubview:line];
    
    return headerV;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
