//
//  ZHOrderDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderDetailVC.h"

#import "OrderDetailCell.h"
#import "ZHAddressChooseView.h"

#import "ZHNewPayVC.h"
#import "OrderVC.h"
#import "SendCommentVC.h"

@interface ZHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic,strong) UILabel *totalPriceLbl;

@property (nonatomic,strong) UILabel *orderCodeLbl;
@property (nonatomic,strong) UILabel *orderTimeLbl;
@property (nonatomic,strong) UILabel *orderStatusLbl;
//@property (nonatomic, strong) UILabel *parameterLbl;
@property (nonatomic, strong) UILabel *noteLabel;   //备注
@property (nonatomic,strong) ZHAddressChooseView *addressView;
//支付方式
@property (nonatomic, strong) UILabel *payLbl;
//物流公司
@property (nonatomic,strong) UILabel *expressNameLbl;
//物流单号
@property (nonatomic,strong) UILabel *expressCodeLbl;


@end


@implementation ZHOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    [self initTableView];
    
    //创建headerView
    [self orderHeaderView];
    //
    [self loadData];
    //
    [self initEventsButton];

}

#pragma mark - 懒加载
- (UIView *)sectionFooterView {
    
    if (!_sectionFooterView) {
        
        _sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 146)];
        
        _sectionFooterView.backgroundColor = [UIColor whiteColor];
        
        //商品总额
        UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                             textAligment:NSTextAlignmentLeft
                                          backgroundColor:[UIColor whiteColor]
                                                     font:Font(14)
                                                textColor:kTextColor];
        [_sectionFooterView addSubview:hintLbl];
        hintLbl.text = @"商品总额";
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15));
            make.top.equalTo(@(0));
            make.height.equalTo(@(45));
            make.width.equalTo(@(75));
            
        }];
        //总额
        _totalPriceLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:Font(16)
                                       textColor:kTextColor];
        
        self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%@", [_order.amount1 convertToSimpleRealMoney]];
        [_sectionFooterView addSubview:self.totalPriceLbl];
        [self.totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.top.equalTo(@(0));
            make.height.equalTo(@(45));
            make.width.lessThanOrEqualTo(@(150));
            
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [_sectionFooterView addSubview:line];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(hintLbl.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(0.5);
            
        }];
        
        //运费
        UILabel *freightLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                                textAligment:NSTextAlignmentLeft
                                             backgroundColor:[UIColor whiteColor]
                                                        font:Font(14)
                                                   textColor:kTextColor];
        freightLbl.text = @"运费";
        
        [_sectionFooterView addSubview:freightLbl];
        
        [freightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15));
            make.top.equalTo(line.mas_bottom);
            make.height.equalTo(@(45));
            make.width.equalTo(@(75));
            
        }];
        
        //运费金额
        UILabel *freightFeeLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:16.0];
        
        freightFeeLbl.textAlignment = NSTextAlignmentRight;
        
        freightFeeLbl.text = [NSString stringWithFormat:@"￥%@", [self.order.yunfei convertToSimpleRealMoney]];
        
        [_sectionFooterView addSubview:freightFeeLbl];
        
        [freightFeeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-15));
            make.top.equalTo(line.mas_bottom);
            make.height.equalTo(@(45));
            make.width.equalTo(@(75));
            
        }];
        
        UIView *secondline = [[UIView alloc] init];
        
        secondline.backgroundColor = kLineColor;
        
        [_sectionFooterView addSubview:secondline];
        [secondline mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(freightLbl.mas_bottom).mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(0.5);
        }];
        UILabel *totalAmountLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight backgroundColor:kClearColor font:Font(18.0) textColor:kTextColor];
        
        //总计=(商品总额+运费)*折扣
        
        CGFloat totalAmount = [_order.amount1 doubleValue] + [_order.yunfei doubleValue];
        
        totalAmountLbl.text = [NSString stringWithFormat:@"支付总价 ￥%@", [@(totalAmount) convertToSimpleRealMoney]];
        
        [_sectionFooterView addSubview:totalAmountLbl];
        [totalAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(secondline.mas_bottom).mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(45);
            
        }];
        
        //
        UIView *bottomLine = [[UIView alloc] init];
        
        bottomLine.backgroundColor = kLineColor;
        
        [_sectionFooterView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(10);
            
        }];
        
    }
    return _sectionFooterView;
}

#pragma mark - Init

- (void)initTableView {
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight) delegate:self dataSource:self];
    
    tableView.rowHeight = [OrderDetailCell rowHeight];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}

- (UIView *)footerViewWithStatus:(NSString *)status {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    footerView.backgroundColor = kClearColor;
    
    //支付方式
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    payView.backgroundColor = [UIColor whiteColor];

    [footerView addSubview:payView];
    
    self.payLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 0, kScreenWidth - 30, 50)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:Font(13)
                                        textColor:kTextColor];
    
    [payView addSubview:self.payLbl];
    
    if ([status isEqualToString:@"2"]) {
        
        return footerView;
    }
    
    UIView *expressView = [[UIView alloc] initWithFrame:CGRectMake(0, payView.yy + 10, kScreenWidth, 70)];
    
    expressView.backgroundColor = [UIColor whiteColor];

    [footerView addSubview:expressView];
    
    self.expressNameLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 16, kScreenWidth - 30, [FONT(13) lineHeight])
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [expressView addSubview:self.expressNameLbl];
    
    self.expressCodeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin,  self.expressNameLbl.yy + 16, kScreenWidth - 30, self.expressNameLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [expressView addSubview:self.expressCodeLbl];
    
    return footerView;
    
    
}

//--//
- ( void )orderHeaderView {
    
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    UIView *headerView = self.tableViewHeaderView;
    
    //
    self.orderCodeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, 16, kScreenWidth - 30, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderCodeLbl];
    
    //
    self.orderTimeLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderCodeLbl.yy + 5, kScreenWidth - 30, self.orderCodeLbl.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderTimeLbl];
    
    //
    self.orderStatusLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderTimeLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(13)
                                        textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.orderStatusLbl];
    
    //
    //    self.parameterLbl = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderStatusLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
    //                                     textAligment:NSTextAlignmentLeft
    //                                  backgroundColor:[UIColor whiteColor]
    //                                             font:FONT(13)
    //                                        textColor:[UIColor zh_textColor]];
    //    [headerView addSubview:self.parameterLbl];
    //    self.parameterLbl.numberOfLines = 0;
    
    self.noteLabel = [UILabel labelWithFrame:CGRectMake(kLeftMargin, self.orderStatusLbl.yy + 5, kScreenWidth - 30,self.orderCodeLbl.height)
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(13)
                                   textColor:[UIColor zh_textColor]];
    [headerView addSubview:self.noteLabel];
    
    //
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.noteLabel.yy + 16, kScreenWidth, 10)];
    [headerView addSubview:lineV];
    lineV.backgroundColor = [UIColor zh_backgroundColor];
    
    //收货信息
    self.addressView = [[ZHAddressChooseView alloc] initWithFrame:CGRectMake(0, lineV.yy, kScreenWidth, 89)];
    self.addressView.type = ZHAddressChooseTypeDisplay;
    [headerView addSubview:self.addressView];
    
    //    //添加约束
    //    [self.parameterLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.equalTo(self.orderStatusLbl.mas_bottom).offset(5);
    //        make.left.equalTo(headerView.mas_left).offset(kLeftMargin);
    //        make.right.lessThanOrEqualTo(headerView.mas_right).offset(-kLeftMargin);
    //
    //    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.noteLabel.mas_bottom).offset(16);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(10);
        
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(lineV.mas_bottom);
        make.height.equalTo(@89);
        //        make.bottom.equalTo(headerView.mas_bottom);
    }];
    
    
}

- (void)loadData {
    
    //********headerView 数据
    OrderDetailModel *detailModel = self.order.productOrderList[0];
    
    self.orderCodeLbl.text = [NSString stringWithFormat:@"订单号：    %@",self.order.code];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"下单时间：%@",[self.order.applyDatetime convertToDetailDate]];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"订单状态：%@",[self.order getStatusName]];
    
    
    //    self.parameterLbl.lineBreakMode = NSLineBreakByCharWrapping;
    //
    //    self.parameterLbl.text = [NSString stringWithFormat:@"产品规格：%@",detailModel.productSpecsName];
    
    self.noteLabel.text = [NSString stringWithFormat:@"备注：       %@", [self.order.applyNote valid]? self.order.applyNote: @"无"];
    
    self.addressView.nameLbl.text = [@"收货人：" add:self.order.receiver];
    self.addressView.mobileLbl.text = self.order.reMobile;
    self.addressView.addressLbl.text = [@"收货地址：" add:self.order.reAddress];
    //********headerView 数据
}

- (void)initEventsButton {
    
    [self.tableViewHeaderView layoutIfNeeded];
    
    self.tableViewHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.addressView.yy);
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    
    if([self.order.status isEqualToString:@"1"]) { //待支付，可取消
        
        self.tableView.height = self.tableView.height - kTabBarHeight;
        
        UIButton *cancleBtn = [UIButton buttonWithTitle:@"取消订单" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:17.0];
        
        cancleBtn.frame = CGRectMake(0, self.tableView.yy, kScreenWidth/2.0, 49);
        [self.view addSubview:cancleBtn];
        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payBtn = [UIButton buttonWithTitle:@"立即支付" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0];
        
        payBtn.frame = CGRectMake(cancleBtn .xx + 1, self.tableView.yy, kScreenWidth/2.0 -  1, 49);
        
        [self.view addSubview:payBtn];
        [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([self.order.status isEqualToString:@"2"]) {
        
        self.tableView.tableFooterView = [self footerViewWithStatus:self.order.status];
        //支付方式组合
        [self payContent];
        
        self.tableView.height = self.tableView.height - kTabBarHeight;
        
        UIButton *refundBtn = [UIButton buttonWithTitle:@"申请退款" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:17.0];
        
        refundBtn.frame = CGRectMake(0, self.tableView.yy, kScreenWidth/2.0, 49);
        [self.view addSubview:refundBtn];
        [refundBtn addTarget:self action:@selector(applyRefund) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *urgeSendGoodBtn = [UIButton buttonWithTitle:@"催货" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0];
        
        urgeSendGoodBtn.frame = CGRectMake(refundBtn .xx + 1, self.tableView.yy, kScreenWidth/2.0 -  1, 49);
        
        [self.view addSubview:urgeSendGoodBtn];
        [urgeSendGoodBtn addTarget:self action:@selector(urgeSendGood) forControlEvents:UIControlEventTouchUpInside];
        
        
    } else if ([self.order.status isEqualToString:@"3"] || [self.order.status isEqualToString:@"4"] || [self.order.status isEqualToString:@"5"]) {// 已发货
        
        //footer
        self.tableView.tableFooterView = [self footerViewWithStatus:self.order.status];
        
        //支付方式组合
        [self payContent];
        
        NSString *name = [self.order.logisticsCompany getExpressName];
        
        self.expressCodeLbl.text = [@"物流单号：" add:self.order.logisticsCode];
        self.expressNameLbl.text = [@"物流公司：" add:name];
        
        if ([self.order.status isEqualToString:@"3"]) {
            
            //收货按钮
            self.tableView.height = self.tableView.height - kTabBarHeight - kBottomInsetHeight;
            UIButton *shBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.yy, kScreenWidth, 49) title:@"确认收货" backgroundColor:kAppCustomMainColor];
            
            [self.view addSubview:shBtn];
            [shBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
            
        } else if ([self.order.status isEqualToString:@"4"]) {
            
            //评价
            self.tableView.height = self.tableView.height - kTabBarHeight - kBottomInsetHeight;
            
            UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.yy, kScreenWidth, 49) title:@"评价" backgroundColor:kAppCustomMainColor];
            
            [self.view addSubview:commentBtn];
            [commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
        }
    }
}

#pragma mark - Events
//取消订单
- (void)cancle {
    
    [TLAlert alertWithTitle:@"" msg:@"确定取消订单？" confirmMsg:@"取消" cancleMsg:@"不取消" placeHolder:@"请输入取消原因" maker:nil cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action, UITextField *textField) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808053";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"remark"] = textField.text;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"取消订单成功"];
            
            if (self.cancleSuccess) {
                
                self.cancleSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];

}

- (void)pay {
    
    BaseWeakSelf;
    //商品购买
    ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
    
    payVC.goodsCodeList = @[_order.code];
    
    CGFloat totalAmount = [_order.amount1 doubleValue] + [_order.yunfei doubleValue];
    
    payVC.rmbAmount = @(totalAmount); //把人民币传过去
    
    payVC.paySucces = ^(){
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[OrderVC class]]) {
                
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
        
        if (weakSelf.paySuccess) {
            
            weakSelf.paySuccess();
        }
    };
    
    payVC.type = ZHPayViewCtrlTypeNewGoods;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}
//申请退款
- (void)applyRefund {
    
    BaseWeakSelf;
    
    [TLAlert alertWithTitle:@"" msg:@"退款申请" confirmMsg:@"确定" cancleMsg:@"取消" placeHolder:@"请输入退款原因"
                      maker:nil cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action, UITextField *textField) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"808061";
        http.parameters[@"code"] = self.order.code;
        http.parameters[@"updater"] = [TLUser user].userId;
        http.parameters[@"remark"] = textField.text;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"退款申请提交成功"];
            
            if (weakSelf.refundSuccess) {
                
                weakSelf.refundSuccess();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

//催货
- (void)urgeSendGood {
    
    [TLAlert alertWithTitle:@"" msg:@"每个订单只能催货一次" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"808058";
        http.parameters[@"code"] = self.order.code;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"催货成功"];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}

//收货
- (void)confirmReceive {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808057";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"确认收货";
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"收货成功"];
        
        if (self.confirmReceiveSuccess) {
            
            self.confirmReceiveSuccess();
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

//评价
- (void)comment {
    
    //对宝贝进行评价
    SendCommentVC *sendCommentVC = [[SendCommentVC alloc] init];
    
    sendCommentVC.type =  SendCommentActionTypeComment;
    sendCommentVC.toObjCode = self.order.code;
    
    sendCommentVC.titleStr = @"评价";
    
    [sendCommentVC setCommentSuccess:^(CommentModel *model){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderList" object:nil];
        
    }];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:sendCommentVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)payContent {
    
    NSMutableString *amount = [NSMutableString stringWithFormat:@"支付方式: "];
    
    if ([self.order.payAmount1 doubleValue] > 0) {
        
        [amount appendString:[NSString stringWithFormat:@"人民币%@", [self.order.payAmount1 convertToSimpleRealMoney]]];
        
        if ([self.order.payAmount2 doubleValue] > 0) {
            
            [amount appendString:[NSString stringWithFormat:@" + 积分%@", [self.order.payAmount2 convertToSimpleRealMoney]]];

            if ([self.order.payAmount3 doubleValue] > 0) {
                
                [amount appendString:[NSString stringWithFormat:@" + 优惠券%@", [self.order.payAmount3 convertToSimpleRealMoney]]];
                
            }
        } else {
            
            if ([self.order.payAmount3 doubleValue] > 0) {
                
                [amount appendString:[NSString stringWithFormat:@" + 优惠券%@", [self.order.payAmount3 convertToSimpleRealMoney]]];
                
            }
        }
        
    } else if ([self.order.payAmount2 doubleValue] > 0) {
        
        [amount appendString:[NSString stringWithFormat:@"积分%@", [self.order.payAmount2 convertToSimpleRealMoney]]];
        
        if ([self.order.payAmount3 doubleValue] > 0) {
            
            [amount appendString:[NSString stringWithFormat:@" + 优惠券%@", [self.order.payAmount3 convertToSimpleRealMoney]]];
            
        }
        
    } else if ([self.order.payAmount3 doubleValue] > 0) {
        
        [amount appendString:[NSString stringWithFormat:@"优惠券%@", [self.order.payAmount3 convertToSimpleRealMoney]]];
        
    }
    
    self.payLbl.text = amount;

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return self.order.productOrderList.count;
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderDetailCellId = @"OrderDetailCell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellId];
    if (!cell) {
        
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellId];
        
    }
    
    cell.order = self.order;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 146;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.sectionFooterView;
}

@end
