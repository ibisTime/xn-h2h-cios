//
//  OrderListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderListVC.h"

#import "OrderModel.h"

#import "OrderGoodsCell.h"
#import "ZHOrderFooterView.h"

#import "ZHOrderDetailVC.h"
#import "ZHNewPayVC.h"
#import "SendCommentVC.h"

@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *tableView;

@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;
//暂无订单
@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirst = YES;

    [self initPlaceHolderView];

    [self initTableView];
    
    [self.tableView beginRefreshing];
    //通知
    [self addNotification];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
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
    
    TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 40) delegate:self dataSource:self];
    
    tableView.rowHeight = 100;
    
    tableView.placeHolderView = self.placeHolderView;

    [self.view addSubview:tableView];

    self.tableView = tableView;
    
    //--//

    //全部（不传） 1 待支付"，2 已支付，3 已发货，4 已收货，5 已评论，6 退款申请，7 退款失败，8 退款成功 ，91取消订单

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808068";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"applyUser"] = [TLUser user].userId;
//    helper.parameters[@"type"] = @"1";
    
    helper.isDeliverCompanyCode = NO;
    
    if (self.status == OrderStatusWillPay) {
        
        helper.parameters[@"statusList"] = @[@"1"];
        
    } else if (self.status == OrderStatusWillSend)  {
        
        helper.parameters[@"statusList"] = @[@"2"];
        
    } else if(self.status == OrderStatusWillReceipt) {
        
        helper.parameters[@"statusList"] = @[@"3"];
        
    } else if(self.status == OrderStatusWillComment) {
        
        helper.parameters[@"statusList"] = @[@"4"];
        
    } else if(self.status == OrderStatusDidComplete) {
        
        helper.parameters[@"statusList"] = @[@"5"];
        
    } else {//全部
        
        helper.parameters[@"orderColumn"] = @"update_datetime";
        helper.parameters[@"orderDir"] = @"desc";
        
    }

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

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:@"RefreshOrderList" object:nil];
}

- (void)refreshOrder {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Events
- (void)orderEventsWithType:(OrderEventsType)type order:(OrderModel *)order {
    
    BaseWeakSelf;
    
    switch (type) {
        case OrderEventsTypeCancel:
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
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

                } failure:^(NSError *error) {
                    
                    
                }];
            }];
            
        }break;
            
        case OrderEventsTypePay:
        {
            //商品购买
            ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
            
            payVC.goodsCodeList = @[order.code];
            
            CGFloat totalAmount = [order.amount1 doubleValue] + [order.yunfei doubleValue];
            
            payVC.rmbAmount = @(totalAmount); //把人民币传过去
            
            payVC.paySucces = ^(){
                
                [weakSelf.navigationController popViewControllerAnimated:YES];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
                

            };
            
            payVC.type = ZHPayViewCtrlTypeNewGoods;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }break;
            
        case OrderEventsTypeApplyRefund:
        {
            [TLAlert alertWithTitle:@"" msg:@"退款申请" confirmMsg:@"确定" cancleMsg:@"取消" placeHolder:@"请输入退款原因"
                              maker:nil cancle:^(UIAlertAction *action) {
                                  
                              } confirm:^(UIAlertAction *action, UITextField *textField) {
                                  
                                  TLNetworking *http = [TLNetworking new];
                                  
                                  http.code = @"808061";
                                  http.parameters[@"code"] = order.code;
                                  http.parameters[@"updater"] = [TLUser user].userId;
                                  http.parameters[@"remark"] = textField.text;
                                  
                                  [http postWithSuccess:^(id responseObject) {
                                      
                                      [TLAlert alertWithSucces:@"退款申请提交成功"];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

                                  } failure:^(NSError *error) {
                                      
                                  }];
                              }];
        }break;
            
        case OrderEventsTypeUrgeSendGood:
        {
            [TLAlert alertWithTitle:@"" msg:@"每个订单只能催货一次" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                
                http.code = @"808058";
                http.parameters[@"code"] = order.code;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"催货成功"];
                    
                } failure:^(NSError *error) {
                    
                }];
            }];
            
        }break;
            
        case OrderEventsTypeConfirmReceiptGood:
        {
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"808057";
            http.parameters[@"code"] = order.code;
            http.parameters[@"updater"] = [TLUser user].userId;
            http.parameters[@"remark"] = @"确认收货";
            http.parameters[@"token"] = [TLUser user].token;
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"收货成功"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

            } failure:^(NSError *error) {
                
                
            }];
        }break;
            
        case OrderEventsTypeComment:
        {
            //对宝贝进行评价
            SendCommentVC *sendCommentVC = [[SendCommentVC alloc] init];
            
            sendCommentVC.type =  SendCommentActionTypeComment;
            sendCommentVC.toObjCode = order.code;
            
            sendCommentVC.titleStr = @"评价";
            
            [sendCommentVC setCommentSuccess:^(CommentModel *model){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
                
            }];
            
            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:sendCommentVC];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        }break;
            
        default:
            break;
    }
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    ZHOrderDetailVC *vc = [[ZHOrderDetailVC alloc] init];
    vc.order = self.orderGroups[indexPath.section];
    
    //未支付订单，支付成功
    vc.paySuccess = ^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

    };
    //取消订单
    vc.cancleSuccess = ^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

    };
    //退款申请提交成功
    vc.refundSuccess = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

    };
    //确认收货
    vc.confirmReceiveSuccess = ^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

    };
    //评价
    vc.commentSuccess = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];

    };
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderModel *model = self.orderGroups[section];
    
    return [self headerViewWithOrderNum:model.code date:model.applyDatetime];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"ZHOrderFooterViewId";
    
    ZHOrderFooterView *footerView = [[ZHOrderFooterView alloc] initWithReuseIdentifier:footerId];
    
    OrderModel *order = self.orderGroups[section];
    
    footerView.orderBlock = ^(OrderEventsType type) {
        
        [weakSelf orderEventsWithType:type order:order];
        
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
