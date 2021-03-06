//
//  ZHPayVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPayVC.h"
#import "ZHPayInfoCell.h"
#import "ZHPayFuncModel.h"
#import "ZHPayFuncCell.h"
#import "TLCurrencyHelper.h"

#import "WXApi.h"
#import "ZHPaySceneManager.h"
#import "TLWXManager.h"
#import "ZHCurrencyModel.h"
#import "TLAlipayManager.h"
#import "TLPwdRelatedVC.h"

@interface ZHPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray <ZHPayFuncModel *>*pays;


//消费金额输入
@property (nonatomic,strong) TLTextField *amountTf;

@property (nonatomic, strong) UIView *payView;
//底部总价
@property (nonatomic,strong) UILabel *priceLbl;

@property (nonatomic,strong) ZHPaySceneManager *paySceneManager;

@property (nonatomic,strong) UITableView *payTableView;

@end



@implementation ZHPayVC

#pragma mark- textField--代理

- (void)canclePay {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.amountTf becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:[NSString stringWithFormat:@"%@", self.shop.name]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
#pragma mark- 检测是否设置了交易密码
//    if (![[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
//        
//        [self setPlaceholderViewTitle:@"您还未设置支付密码" operationTitle:@"前往设置"];
//        [self addPlaceholderView];
//        
//    } else {//
//        
//        [self beginLoad];
//        
//    }
    [self beginLoad];
#pragma mark- 除汇赚宝外  获得余额
    //首先获得总额
    //    TLNetworking *http2 = [TLNetworking new];
    //    http2.code = @"808801";
    //    http2.parameters[@"userId"] = [TLUser user].userId;
    //    http2.parameters[@"token"] = [TLUser user].token;
    //    [http2 postWithSuccess:^(id responseObject) {
    //
    //      NSNumber *surplusMoney =  responseObject[@"data"];
    //      self.pays[0].payName = [NSString stringWithFormat:@"余额(%@)",[surplusMoney convertToRealMoney]];
    //      [self.payTableView reloadData];
    //
    //
    //    } failure:^(NSError *error) {
    //
    //
    //    }];
    
    //addNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.payView.y = CGRectGetMinY(keyBoardFrame) - kNavigationBarHeight - self.payView.height;
        
        
    } completion:NULL];
    
    
}

- (void)tl_placeholderOperation {
    
    TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
    [self.navigationController pushViewController:pwdAboutVC animated:YES];
    
    [pwdAboutVC setSuccess:^{
        
        //       [self removePlaceholderView];
        [self beginLoad];
        
    }];
    
}

- (void)beginLoad {
    
    //--//
    NSArray *imgs = @[@"zh_pay",@"we_chat",@"alipay"];
    NSArray *payNames;
    
    NSString *balancePay = [NSString stringWithFormat:@"健康币支付(余额: %@)", [[TLUser user].rmbNum convertToRealMoney]];

    payNames  = @[balancePay,@"微信支付",@"支付宝"]; //余额(可用100)
    
    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeWeChat),@(ZHPayTypeAlipay)];
    NSArray <NSNumber *>*status = @[@(YES),@(NO),@(NO)];
    
//    NSArray *imgs = @[@"zh_pay",@"alipay"];
//    NSArray *payNames;
//    payNames  = @[@"健康币支付",@"支付宝"]; //余额(可用100)
    
//    NSArray *payType = @[@(ZHPayTypeOther),@(ZHPayTypeAlipay)];
//    NSArray <NSNumber *>*status = @[@(YES),@(NO)];
    
    self.pays = [NSMutableArray array];
    
    NSInteger count = imgs.count;
    
    
    //全部转换为支付模型
    for (NSInteger i = 0; i < count; i ++) {
        
        ZHPayFuncModel *zhPay = [[ZHPayFuncModel alloc] init];
        zhPay.payImgName = imgs[i];
        zhPay.payName = payNames[i];
        zhPay.isSelected = [status[i] boolValue];
        zhPay.payType = [payType[i] integerValue];
        [self.pays addObject:zhPay];
        
    }
    
    //--//
    self.paySceneManager = [[ZHPaySceneManager alloc] init];
    self.paySceneManager.isInitiative = YES;
    
    //1.第一组
    ZHPaySceneUIItem *priceItem = [[ZHPaySceneUIItem alloc] init];
    priceItem.headerHeight = 10.0;
    priceItem.footerHeight = 10.0;
    priceItem.rowNum = 2;
    
    //3.支付
    ZHPaySceneUIItem *payFuncItem = [[ZHPaySceneUIItem alloc] init];
    payFuncItem.headerHeight = 30.0;
    payFuncItem.footerHeight = 0.1;
    payFuncItem.rowNum = self.pays.count;
    
    self.paySceneManager.groupItems = @[priceItem,payFuncItem];
    
    
    //界面
    [self setUpUI];
    
#pragma mark- 微信支付回调
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
    
#pragma mark- 支付宝支付回调
    [[TLAlipayManager manager] setPayCallBack:^(BOOL isSuccess, NSDictionary *resultDict){
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"支付成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            
        } else {
            
            [TLAlert alertWithError:@"支付失败"];
            
        }
        
    }];
    
}


#pragma mark- 支付
- (void)pay {
    
    __block ZHPayType type;
    [self.pays enumerateObjectsUsingBlock:^(ZHPayFuncModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            type = obj.payType;
            *stop = YES;
        }
        
    }];
    
    
    if (![self.amountTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入消费金额"];
        return;
        
    }
    
    
    
    NSString *payType;
    switch (type) {
        case ZHPayTypeAlipay: {
            
            payType = @"3";
            
        }
            break;
        case ZHPayTypeWeChat: {
            
            payType = @"2";
        }
            break;
            
        case ZHPayTypeOther: {
            
            payType = @"1";
        }
            break;
    }
    
    
    if (type == ZHPayTypeOther) {
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"确定要支付?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            
//            textField.secureTextEntry = YES;
//            
//        }];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            if (![alertCtrl.textFields[0].text valid]) {
//                
//                [TLAlert alertWithInfo:@"请输入支付密码"];
//                
//            } else {
//                
//                [self shopPay:payType payPwd:alertCtrl.textFields[0].text];
//            }
            [self shopPay:payType payPwd:nil];

            
        }]];
        
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
        
    } else {
        
        [self shopPay:payType payPwd:nil];
        
    }
    
}

#pragma mark- 优店支付, 健康币支付需要支付密码
- (void)shopPay:(NSString *)payType payPwd:(nullable NSString *)pwd {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808271";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"storeCode"] = self.shop.code;
    
    http.parameters[@"tradePwd"] = pwd;
    
    http.parameters[@"amount"] = [self.amountTf.text convertToSysMoney];
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"payType"] = payType;
    
    [http postWithSuccess:^(id responseObject) {
        
        
        if ([payType isEqualToString: @"2"]) {
            
            [self wxPayWithInfo:responseObject[@"data"]];
            
        } else if([payType isEqualToString: @"3"]) {
            
            [self aliPayWithInfo:responseObject[@"data"]];
            
            
        } else {
            
            [TLAlert alertWithSucces:@"支付成功"];
            
            if (self.paySucces) {
                self.paySucces();
            }
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)aliPayWithInfo:(NSDictionary *)info {
    
    
    //支付宝回调
    [TLAlipayManager payWithOrderStr:info[@"signOrder"]];
    
    [TLAlipayManager manager];
    
    
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
    
    if([WXApi sendReq:req]){
        
        
    } else {
        
        [TLAlert alertWithError:@"支付失败"];
        
    }
    
}

//
- (void)setUpUI {
    
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:payTableView];
    self.payTableView = payTableView;
    payTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    payTableView.rowHeight = 50;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    payTableView.dataSource = self;
    payTableView.delegate = self;
    
    //底部支付相关
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, payTableView.yy, kScreenWidth, 49)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    self.payView = payView;
    
    //按钮
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, payView.height) title:@"确认支付" backgroundColor:kAppCustomMainColor];
    [payView addSubview:payBtn];
    payBtn.titleLabel.font = [UIFont secondFont];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 70, payView.height)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:[UIFont secondFont]
                                      textColor:[UIColor zh_textColor]];
    [payView addSubview:titleLbl];
    titleLbl.text = @"实际支付:";
    //
    UILabel *payAmountLbl = [UILabel labelWithFrame:CGRectMake(titleLbl.xx + 10, 0, kScreenWidth - titleLbl.xx - 10 - payBtn.width, payBtn.height)
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont secondFont]
                                          textColor:[UIColor zh_themeColor]];
    [payView addSubview:payAmountLbl];
    payAmountLbl.text = @"";
    payAmountLbl.numberOfLines = 0;
    self.priceLbl = payAmountLbl;
    
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
    
    
    if (indexPath.section == 1) {
        
        static NSString * payFuncCellId = @"ZHPayFuncCell";
        ZHPayFuncCell  *cell = [tableView dequeueReusableCellWithIdentifier:payFuncCellId];
        if (!cell) {
            cell = [[ZHPayFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payFuncCellId];
        }
        cell.pay = self.pays[indexPath.row];
        
        return cell;
        
    }
    
    
    //支付金额-- 和优惠券
    ZHPayInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
    
    if (!infoCell) {
        
        infoCell = [[ZHPayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            infoCell.titleLbl.text = @"消费金额";
            infoCell.hidenArrow = YES;
            
            [infoCell addSubview:self.amountTf];
        } else {
            infoCell.titleLbl.text = @"商家折扣";
            infoCell.hidenArrow = YES;
            infoCell.infoLbl.textAlignment = NSTextAlignmentRight;
            
            
            infoCell.infoLbl.text = [NSString stringWithFormat:@"%@折", [_shop.rate1 convertToCountMoney]];
            
            
            //            [infoCell addSubview:self.tradePwdTf];
            
        }
        
        
    }
    
    
    //    else if (indexPath.section == 1 ) {
    //
    //        //
    //        infoCell.titleLbl.text = @"使用抵扣券";
    //        if (self.coupons.count > 0) {
    //
    //            infoCell.infoLbl.text = @"请选择折扣券";
    //
    //        } else {
    //
    //            infoCell.infoLbl.text = @"还没有折扣券";
    //
    //        }
    //        [infoCell.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
    //
    //            make.width.mas_equalTo(100);
    //        }];
    //        self.couponsCell = infoCell;
    //        infoCell.hidenArrow = NO;
    //
    //    }
    return infoCell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //支持点击整个cell,选择支付方式
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHPayFuncCell class]]) {
        
        //----不是余额把 支付密码隐藏掉----//
        if (self.pays[indexPath.row].isSelected) {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PAY_TYPE_CHANGE_NOTIFICATION" object:nil userInfo:@{@"sender" : cell}];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (section == 1) {
        return [self payFuncHeaderView];
    }
    
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.footerHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    ZHPaySceneUIItem *item = self.paySceneManager.groupItems[section];
    return item.headerHeight;
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


//- (TLTextField *)tradePwdTf {
//
//    if (!_tradePwdTf) {
//
//        _tradePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 1, kScreenWidth - 100, 47)];
//        _tradePwdTf.backgroundColor = [UIColor whiteColor];
//        _tradePwdTf.placeholder = @"请输入支付密码";
//        _tradePwdTf.secureTextEntry = YES;
//        _tradePwdTf.delegate = self;
//    }
//
//    return _tradePwdTf;
//
//}

- (TLTextField *)amountTf {
    
    if (!_amountTf) {
        
        _amountTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 1, kScreenWidth - 100, 47)];
        _amountTf.backgroundColor = [UIColor whiteColor];
        _amountTf.placeholder = @"请输入消费金额";
        _amountTf.delegate = self;
        _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
        
        [_amountTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _amountTf;
    
}

- (void)textDidChange:(UITextField *)sender {
    
    if (!sender.text && sender.text.length <= 0) {
        
        self.priceLbl.text = @"0";
        return ;
    }
    
    CGFloat price = [sender.text doubleValue]*[_shop.rate1 doubleValue];
    
    price = round(price*1000)/1000;
    
    //小数点进1

    long long m = price*1000;
    
    if (m%10 > 0) {
        
        price = ceil(price*100)/100;

    }
    
    NSString *countPrice = [NSString stringWithFormat:@"%.2f", price];
    
    self.priceLbl.text = countPrice;
}

@end
