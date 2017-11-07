//
//  ZHNewPayVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHNewPayVC.h"

#import "ZHPayInfoCell.h"
#import "ZHPayFuncCell.h"
#import "CouponView.h"

#import "CurrencyModel.h"
#import "ZHPayFuncModel.h"
#import "CouponModel.h"
#import "TLCurrencyHelper.h"
#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLGroupModel.h"

#import "TLPwdRelatedVC.h"

#define PAY_TYPE_DEFAULT_PAY_CODE @"1"
#define PAY_TYPE_WX_PAY_CODE @"2"
#define PAY_TYPE_ALI_PAY_CODE @"3"
#define PAY_TYPE_BAL_PAY_CODE @"4"

@interface ZHNewPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;

@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) TLTableView *payTableView;
//优惠券
@property (nonatomic, strong) NSArray <CouponModel *>*coupons;

@property (nonatomic, strong) UIButton *conponBtn;

@property (nonatomic, strong) CouponView *couponView;
//选择的优惠券
@property (nonatomic, assign) NSInteger currentIndex;
//积分
@property (nonatomic, strong) CurrencyModel *jfModel;

@end

@implementation ZHNewPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //暂时去掉邮费
    self.postage = nil;
    
    [self beginLoad];
}

- (CouponView *)couponView {
    
    if (!_couponView) {
        
        BaseWeakSelf;
        
        _couponView = [[CouponView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _couponView.coupons = self.coupons;
        
        _couponView.done = ^(NSInteger index) {
          
            weakSelf.currentIndex = index;
            
            NSString *text;
            
            ZHPayFuncModel *couponModel = weakSelf.pays[3];

            if (index == 0) {
                
                text = @"选择优惠券";
                
                couponModel.isSelected = NO;

            } else {
                
                CouponModel *coupon = weakSelf.coupons[index - 1];
                
                text= [NSString stringWithFormat:@"减%@元", [coupon.parValue convertToSimpleRealMoney]];
                
                couponModel.isSelected = YES;
                
            }
                              
            [weakSelf.conponBtn setTitle:text forState:UIControlStateNormal];
            
            CGFloat btnW = [NSString getWidthWithString:text font:15.0] + 8 + 6;
            
            [weakSelf.conponBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(btnW);
                
            }];
            
            [weakSelf.conponBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -weakSelf.conponBtn.imageView.frame.size.width - weakSelf.conponBtn.frame.size.width + weakSelf.conponBtn.titleLabel.intrinsicContentSize.width, 0, 0)];
            [weakSelf.conponBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -weakSelf.conponBtn.titleLabel.frame.size.width - weakSelf.conponBtn.frame.size.width + weakSelf.conponBtn.imageView.frame.size.width)];
        };
        
    }
    return _couponView;
}

- (void)canclePay {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tl_placeholderOperation {
    
    TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
    [self.navigationController pushViewController:pwdAboutVC animated:YES];
    
    [pwdAboutVC setSuccess:^{
        
        [self removePlaceholderView];
        
        [self beginLoad];
        
    }];
}

- (void)beginLoad {
    //初始化支付模型
    [self initPayModel];
    
    //--//
    self.paySceneManager = [[ZHPaySceneManager alloc] init];
    
    switch (self.type) {
            
        case ZHPayViewCtrlTypeHZB: { //购买汇赚宝
            
        } break;
            
        case ZHPayViewCtrlTypeNewYYDB: { //2.0版本的一元夺宝
            
        } break;
            
        case ZHPayViewCtrlTypeNewGoods: { //普通商品支付
            
            self.paySceneManager.isInitiative = NO;
            self.paySceneManager.amount = [self.rmbAmount convertToSimpleRealMoney];
            
            //1.第一组
            ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
            priceItem.headerHeight = 0.1;
            priceItem.footerHeight = 10.0;
            
            if (self.postage) {
                
                priceItem.rowNum = 2;
                
            } else {
                
                priceItem.rowNum = 1;
            }
            
            //2.支付
            ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
            payFuncItem.headerHeight = 30.0;
            payFuncItem.footerHeight = 50;
            payFuncItem.rowNum = self.pays.count;
            self.paySceneManager.groupItems = @[priceItem,payFuncItem];
            //创建tableview
            [self setUpUI];
            //获取用户优惠券列表
            [self requestCouponList];
            //获取用户余额
            [self requestUserBalance];
            
        } break;
            
        default: [TLAlert alertWithInfo:@"您还没有选择支付场景"];
            
    }

}

- (void)initPayModel {
    
    NSArray *imgs;
    NSArray *payNames;
    NSArray *payType = @[@(ZHPayTypeBalance),@(ZHPayTypeWeChat), @(ZHPayTypeIntegral)];
    
    NSArray <NSNumber *>*status = @[@(YES), @(NO), @(NO)];
    
    NSString *balancePay = [NSString stringWithFormat:@"余额"];
    
    payNames = @[balancePay,@"微信支付", @"积分"]; //余额(可用100)
    imgs = @[@"balance",@"wx_pay",@"integral_pay"];
    
    self.pays = [NSMutableArray array];
    
    //隐藏掉支付宝
    NSInteger count = payNames.count;
    
    //只创建可以支付的支付方式，， 一元夺宝只有 健康币支付 就显示余额
    for (NSInteger i = 0; i < count; i ++) {
        
        ZHPayFuncModel *zhPay = [[ZHPayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
}

//
- (void)setUpUI {
    
    TLTableView *payTableView = [TLTableView groupTableViewWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) delegate:self dataSource:self];
    
    payTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    payTableView.rowHeight = 50;
    
    [self.view addSubview:payTableView];
    
    self.payTableView = payTableView;
    
    //底部支付相关
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, payTableView.yy, kScreenWidth, 115)];
    
    payTableView.tableFooterView = payView;
    
    //按钮
    UIButton *payBtn = [UIButton buttonWithTitle:@"立即支付" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    payBtn.frame = CGRectMake(15, 35, kScreenWidth - 2*15, 45);
    
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:payBtn];
    
}

#pragma mark - Data
- (void)requestCouponList {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"801118";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"status"] = @"0";
    //用户ID
    helper.parameters[@"toUser"] = [TLUser user].userId;
    //降序
    helper.parameters[@"orderDir"] = @"desc";
    //按金额排序
    helper.parameters[@"orderColumn"] = @"par_value";
    
    [helper modelClass:[CouponModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.coupons = objs;
        
        [self.payTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
//获取积分兑换人民币比例
- (void)requestProportion {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808917";
    http.parameters[@"key"] = @"jf_dk_times";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *num = responseObject[@"data"][@"cvalue"];
        
        if (self.pays.count > 0) {
            
            ZHPayFuncModel *balanceModel = self.pays[2];

            NSString *balancePay = [NSString stringWithFormat:@"积分(可用余额: %@, %@积分抵扣1人民币)", [self.jfModel.amount convertToSimpleRealMoney], num];
            
            balanceModel.payName = balancePay;
//
            [self.payTableView reloadData];
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)requestUserBalance {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"JF"]) {
                
                self.jfModel = obj;
                //获取积分兑换人民币比例
                [self requestProportion];
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                ZHPayFuncModel *balanceModel = self.pays[0];
                
                NSString *balancePay = [NSString stringWithFormat:@"余额(可用余额: %@)", [obj.amount convertToSimpleRealMoney]];
                
                balanceModel.payName = balancePay;
                
                [self.payTableView reloadData];

            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events
- (void)clickSelectCoupon:(UIButton *)sender {
    
    if (self.coupons.count == 0) {
        
        [TLAlert alertWithInfo:@"暂无优惠券"];
        return ;
    }
    
    [self.couponView show];
}

#pragma mark- 支付
- (void)pay {
    
    if (self.pays.count <= 0) {
        
        return ;
    }
    //余额
    ZHPayFuncModel *balanceModel = self.pays[0];
    //微信
    ZHPayFuncModel *wxPayModel = self.pays[1];
    //积分
    ZHPayFuncModel *integralModel = self.pays[2];
    //优惠券
    ZHPayFuncModel *couponModel = self.pays[3];

    NSInteger payType;

    if (self.type == ZHPayViewCtrlTypeNewGoods) {
        //0、积分支付，1、余额支付，2、微信APP支付，5、微信H5支付，60、优惠券支付，61、积分+H5支付，62、积分+余额支付，63、积分+优惠券支付，64、微信H5+优惠券支付，65、余额+优惠券支付，66、积分+微信APP支付，67、优惠券+微信APP支付，68、积分+微信H5支付+优惠券，69、积分+余额支付+优惠券，70、积分+微信APP支付+优惠券
        if (balanceModel.isSelected) {
            //余额支付
            payType = 1;
            
            if (balanceModel.isSelected && integralModel.isSelected && !couponModel.isSelected) {
                //积分+余额支付
                payType = 62;
                
            } else if (balanceModel.isSelected && couponModel.isSelected && !integralModel.isSelected) {
                //余额+优惠券支付
                payType = 65;
                
            } else if (balanceModel.isSelected && integralModel.isSelected && couponModel.isSelected) {
                //积分+余额支付+优惠券
                payType = 69;
            }
            
        } else if (wxPayModel.isSelected) {
            
            payType = 2;
            
            if (wxPayModel.isSelected && integralModel.isSelected && !couponModel.isSelected) {
                //积分+微信支付
                payType = 66;
                
            } else if (wxPayModel.isSelected && couponModel.isSelected && !integralModel.isSelected) {
                //微信+优惠券支付
                payType = 67;
                
            } else if (wxPayModel.isSelected && integralModel.isSelected && couponModel.isSelected) {
                //积分+微信支付+优惠券
                payType = 70;
            }
            
            [self goodsPay:[NSString stringWithFormat:@"%ld", payType] payPwd:nil];
            
            return ;

        } else if (integralModel.isSelected) {
            //积分支付
            payType = 0;
            
            if (integralModel.isSelected && couponModel.isSelected) {
                //积分+优惠券支付
                payType = 63;
            }
            
        } else {
            
            //优惠券支付
            payType = 60;
        }
        
        //提示用户
        [self showAlertWithPayType:payType];
    }

}

- (void)showAlertWithPayType:(NSInteger)payType {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"确定要支付?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self goodsPay:[NSString stringWithFormat:@"%ld", payType] payPwd:nil];
        
    }]];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}


- (void)wxPayWithInfo:(NSDictionary *)info {
    
    NSDictionary *dict = info;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"wechatPackage"];
    req.sign                = [dict objectForKey:@"sign"];
    
    if([WXApi sendReq:req]) {
        
    } else {
        
        [TLAlert alertWithError:@"支付失败"];
    }
    
    BaseWeakSelf;
    
    [TLWXManager manager].wxPay = ^(BOOL isSuccess,int errorCode){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                
                [TLAlert alertWithSucces:@"支付成功"];
                
                if (weakSelf.paySucces) {
                    
                    weakSelf.paySucces();
                }
                
            } else {
                
                [TLAlert alertWithError:@"支付失败"];
            }
        });
    };
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    BaseWeakSelf;
    
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    //支付宝回调
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"支付成功"];
            
            if (weakSelf.paySucces) {
                
                weakSelf.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"支付失败"];
        }
    }];
}

//尖货支付
- (void)goodsPay:(NSString *)payType payPwd:(NSString *)pwd {

    if (!self.goodsCodeList) {
        
        NSLog(@"请填写订单信息");
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808052";
    http.parameters[@"codeList"] = self.goodsCodeList;
    http.parameters[@"payType"] = payType;
    if (self.currentIndex != 0) {
        
        CouponModel *coupon = self.coupons[self.currentIndex - 1];
        
        http.parameters[@"couponCode"] = coupon.code;

    }
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([payType isEqualToString:PAY_TYPE_ALI_PAY_CODE]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];

        } else if([payType isEqualToString:PAY_TYPE_WX_PAY_CODE]) {
        
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else {
        
            [TLAlert alertWithSucces:@"购买成功"];
            
            if (self.paySucces) {
                
                self.paySucces();
            }
        }
     
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.paySceneManager.groupItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    
    return item.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 1) { //支付方式的组
        
        static NSString * payFuncCellId = @"ZHPayFuncCell";
        ZHPayFuncCell  *cell = [tableView dequeueReusableCellWithIdentifier:payFuncCellId];
        if (!cell) {
            cell = [[ZHPayFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payFuncCellId];
        }
        cell.pay = self.pays[indexPath.row];
        
        cell.tag = 2000 + indexPath.row;
        
        return cell;
        
    }
    //支付金额
    ZHPayInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
    
    if (!infoCell) {
        
        infoCell = [[ZHPayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
    }
    
    if (indexPath.row == 0) {
        
        infoCell.titleLbl.text = @"支付金额";
        infoCell.hidenArrow = YES;
        infoCell.infoLbl.textAlignment = NSTextAlignmentLeft;
        infoCell.infoLbl.text = [NSString stringWithFormat:@"￥%@", [_rmbAmount convertToSimpleRealMoney]];
        
    } else if (self.postage && indexPath.row == 1) {
        
        infoCell.titleLbl.text = @"邮费(元)";
        infoCell.hidenArrow = YES;
        infoCell.infoLbl.textAlignment = NSTextAlignmentLeft;
        infoCell.infoLbl.text = [self.postage convertToRealMoney];
        
    }
    
    return infoCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    BOOL con1 = self.pays[indexPath.row].payType == ZHPayTypeWeChat;
    //    BOOL con2 = [WXApi isWXAppInstalled];
    //    if (con1 && !con2) {
    //        [TLAlert alertWithInfo:@"您还未安装微信,不能进行微信支付"];
    //        return;
    //    }
    //支持点击整个cell,选择支付方式
    
    ZHPayFuncCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ZHPayFuncCell *balanceCell = (ZHPayFuncCell *)[tableView viewWithTag:2000];
    
    ZHPayFuncCell *wxCell = (ZHPayFuncCell *)[tableView viewWithTag:2001];
    //余额
    ZHPayFuncModel *balanceModel = self.pays[0];
    //微信
    ZHPayFuncModel *wxPayModel = self.pays[1];
    
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
        
        cell.selectedBtn.selected = !cell.selectedBtn.selected;
        
        cell.pay.isSelected = cell.selectedBtn.selected;
        
        if (cell.pay.payType == ZHPayTypeBalance) {
            
            wxPayModel.isSelected = NO;
            
            wxCell.selectedBtn.selected = NO;
            
        } else if (cell.pay.payType == ZHPayTypeWeChat) {
            
            balanceModel.isSelected = NO;
            
            balanceCell.selectedBtn.selected = NO;
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    
    return item.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        //添加优惠券model
        ZHPayFuncModel *couponPay = [[ZHPayFuncModel alloc] init];
        
        couponPay.payImgName = @"coupon_pay";
        couponPay.payName = @"优惠券支付";
        couponPay.isSelected = NO;
        couponPay.payType = ZHPayTypeCouponPay;
        
        [self.pays addObject:couponPay];
        
        //优惠券
        UIView *couponView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        
        couponView.backgroundColor = kWhiteColor;
        //icon
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25,25)];
        
        iconIV.image = kImage(couponPay.payImgName);
        
        [couponView addSubview:iconIV];
        //title
        UILabel *textLbl = [UILabel labelWithText:couponPay.payName textColor:kTextColor textFont:13.0];
        
        [couponView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(iconIV.mas_right).mas_equalTo(10);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(100);
            
        }];
        //button
        
        NSString *text = @"";
        
        if (self.coupons != nil) {
            
            text = self.coupons.count == 0 ? @"暂无优惠券": @"选择优惠券";

        }
        
        UIButton *selectBtn = [UIButton buttonWithTitle:text titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
        
        [selectBtn setImage:kImage(@"更多") forState:UIControlStateNormal];
        
        [selectBtn addTarget:self action:@selector(clickSelectCoupon:) forControlEvents:UIControlEventTouchUpInside];
        [couponView addSubview:selectBtn];
        
        CGFloat btnW = [NSString getWidthWithString:text font:15.0] + 8 + 6;

        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(btnW);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            
        }];
        
        [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -selectBtn.imageView.frame.size.width - selectBtn.frame.size.width + selectBtn.titleLabel.intrinsicContentSize.width, 0, 0)];
        [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -selectBtn.titleLabel.frame.size.width - selectBtn.frame.size.width + selectBtn.imageView.frame.size.width)];
        
        self.conponBtn = selectBtn;

        return couponView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return [self payFuncHeaderView];
    }
    
    return nil;
}

- (UIView *)payFuncHeaderView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(15, 0, kScreenWidth - 35, headView.height)
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor zh_textColor]];
    lbl.text = @"支付方式";
    [headView addSubview:lbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor zh_lineColor];
    [headView addSubview:lineView];
    
    return headView;
}

@end
