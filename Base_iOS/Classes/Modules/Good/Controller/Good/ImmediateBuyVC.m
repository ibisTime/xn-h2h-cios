//
//  ImmediateBuyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ImmediateBuyVC.h"

#import "ZHAddressChooseVC.h"
#import "ZHNewPayVC.h"
#import "ZHAddAddressVC.h"
#import "GoodDetailVC.h"
//#import "ZHShoppingCartVC.h"

#import "GoodInfoCell.h"
#import "ZHAddressChooseView.h"

#import "ZHReceivingAddress.h"
#import "TLCurrencyHelper.h"

#import "UIView+Custom.h"

//#import "ZHCartManager.h"
//
//#import "ZHCartGoodsModel.h"

@interface ImmediateBuyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *totalPriceLbl;

//
//@property (nonatomic,strong) UILabel *nameLbl;
//@property (nonatomic,strong) UILabel *mobileLbl;
//@property (nonatomic,strong) UILabel *addressLbl;

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIImageView *arrowIV;
@property (nonatomic, strong) UIView *buyView;

@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) TLTextField *enjoinTf;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;
@property (nonatomic,strong) ZHAddressChooseView *chooseView;

@property (nonatomic, strong) NSNumber *totalAmount;

@end

@implementation ImmediateBuyVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单提交";
    
    if (self.type == IMBuyTypeSingle) { //---单买
        
        if (!self.good) {
            
            return;
        }
        
        NSNumber *amount = @([self.good.price doubleValue]*[self.good.discount doubleValue]);
        
        NSString *totalPrice = [NSString stringWithFormat:@"%@", [amount convertToSimpleRealMoney]];
        
        self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%@", totalPrice];
    }
    
    //根据有无地址创建UI
    [self getAddress];
}

#pragma mark - 懒加载
- (ZHAddressChooseView *)chooseView {
    
    if (!_chooseView) {
        
        __weak typeof(self) weakself = self;
        //头部有个底 可以添加，有地址时的ui和无地址时的ui
        _chooseView = [[ZHAddressChooseView alloc] initWithFrame:self.headerView.bounds];
        _chooseView.chooseAddress = ^(){
            
            [weakself chooseAddress];
        };
    }
    return _chooseView;
    
}

- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 136)];
    footerView.backgroundColor = [UIColor whiteColor];
    TLTextField *tf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"买家嘱咐: " titleWidth:100 placeholder:@"对本次交易的说明"];
    [footerView addSubview:tf];
    self.enjoinTf = tf;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tf.yy + 1, kScreenWidth, 0.5)];
    line.backgroundColor = kLineColor;
    [footerView addSubview:line];
    //商品总额
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor whiteColor]
                                                 font:Font(14)
                                            textColor:kTextColor];
    [footerView addSubview:hintLbl];
    hintLbl.text = @"商品总额";
    
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(footerView.mas_left).offset(15);
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    //总额
    [footerView addSubview:self.totalPriceLbl];
    [self.totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@(45));
        make.width.lessThanOrEqualTo(@(150));
        
    }];
    
    UIView *secondline = [[UIView alloc] initWithFrame:CGRectMake(0, tf.yy + 46, kScreenWidth, 0.5)];
    secondline.backgroundColor = kLineColor;
    
    [footerView addSubview:secondline];
    //运费
    UILabel *freightLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                            textAligment:NSTextAlignmentLeft
                                         backgroundColor:[UIColor whiteColor]
                                                    font:Font(14)
                                               textColor:kTextColor];
    freightLbl.text = @"运费";

    [footerView addSubview:freightLbl];
    
    [freightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(secondline.mas_bottom);
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    
    //运费金额
    UILabel *freightFeeLbl = [UILabel labelWithText:@"" textColor:kThemeColor textFont:16.0];
    
    freightFeeLbl.textAlignment = NSTextAlignmentRight;
    
    freightFeeLbl.text = [NSString stringWithFormat:@"￥%@", [self.good.yunfei convertToSimpleRealMoney]];
    
    [footerView addSubview:freightFeeLbl];
    
    [freightFeeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(secondline.mas_bottom);
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    
    return footerView;
    
}

//#pragma mark- 有收获地址时的头部UI
- (void)setHaveAddressUI {
    
    if (self.headerView.subviews.count > 0) {
        
        [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.view addSubview:self.headerView];
    }
    [self.headerView addSubview:self.chooseView];
    
}

//
- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 90)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
    
}

- (UITableView *)tableV{
    
    if (!_tableV) {
        
        //无收货地址
        TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight - kBottomInsetHeight) delegate:self dataSource:self];
        tableView.tableHeaderView = self.headerView;
        tableView.tableFooterView = [self footerView];
        _tableV = tableView;
    }
    return _tableV;
    
}

- (UIView *)buyView {
    
    if (!_buyView) {
        
        _buyView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - 50 - kBottomInsetHeight, kScreenWidth, 50)];
        
        _buyView.backgroundColor = kWhiteColor;
        
        UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50) textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(14.0) textColor:kTextColor];
        
        ;
        
        //总计=商品总额*折扣+运费
        
        CGFloat totalAmount = [_good.price doubleValue]*[_good.discount doubleValue] + [_good.yunfei doubleValue];
        
        self.totalAmount = @(totalAmount);
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%@", [@(totalAmount) convertToSimpleRealMoney]];
        
        [totalPriceLbl labelWithString:[NSString stringWithFormat:@"总计: %@", priceStr] title:priceStr font:Font(18.0) color:kThemeColor];
        
        [_buyView addSubview:totalPriceLbl];
        
        _buyBtn = [UIButton buttonWithTitle:@"确认购买" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
        
        _buyBtn.frame = CGRectMake(kScreenWidth - 110 - 15, 7, 110, 36);
        
        [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_buyView addSubview:_buyBtn];
    }
    return _buyView;
}

- (UILabel *)totalPriceLbl {
    
    if (!_totalPriceLbl) {
        _totalPriceLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:Font(16)
                                       textColor:kThemeColor];
    }
    
    return _totalPriceLbl;
}

#pragma mark- 立即购买行为
- (void)buyAction {
    
    if (!self.currentAddress) {
        
        [TLAlert alertWithInfo:@"请选择收货地址"];
        return;
    }
    
    BaseWeakSelf;
    //
    if (self.type == IMBuyTypeSingle && self.good) { //普通商品购买
        
        //单个购买
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808060";
        http.parameters[@"productCode"] = self.good.code;
        
        http.parameters[@"quantity"] = @"1";
        
        http.parameters[@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"reMobile"] = self.currentAddress.mobile;
        
        http.parameters[@"applyUser"] = [TLUser user].userId;
        http.parameters[@"companyCode"] = [AppConfig config].companyCode;
        http.parameters[@"systemCode"] = [AppConfig config].systemCode;
        
        //根据收货地址
        NSString *note = [self.enjoinTf.text valid] ? self.enjoinTf.text: @"无";
        
        http.parameters[@"applyNote"] = note;
        
        [http postWithSuccess:^(id responseObject) {
            
            //订单编号
            NSString *orderCode = responseObject[@"data"][@"code"];
            
            //商品购买
            ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
            
            payVC.goodsCodeList = @[orderCode];
            
            payVC.rmbAmount = self.totalAmount; //把人民币传过去
            
            //邮费
            payVC.postage = self.postage;
            
            payVC.paySucces = ^(){
                
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[GoodDetailVC class]]) {
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];

            };
            payVC.type = ZHPayViewCtrlTypeNewGoods;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
        
        return;
    }
}

- (void)getAddress {
    
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    http.code = @"805165";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"isDefault"] = @"1"; //是否为默认收货地址
    
    [http postWithSuccess:^(id responseObject) {
        
        //添加
        [self.view addSubview:self.tableV];
        //购买
        [self.view addSubview:self.buyView];
        
        NSArray *adderssRoom = responseObject[@"data"];
        
        if (adderssRoom.count > 0 ) { //有收获地址
            
            self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];
            //给一个默认地址
            self.currentAddress = self.addressRoom[0];
            self.currentAddress.isSelected = YES;
            
            [self setHeaderAddress:self.currentAddress];
            
            
        } else { //没有收货地址，展示没有的UI
            
            self.addressRoom = [NSMutableArray array];
            
            [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [self setNOAddressUI];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)setHeaderAddress:(ZHReceivingAddress *)address {
    
    [self setHaveAddressUI];
    
    self.chooseView.nameLbl.text = [NSString stringWithFormat:@"收货人：%@",address.addressee];
    self.chooseView.mobileLbl.text = [NSString stringWithFormat:@"%@",address.mobile];
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@·%@",address.province,address.city, address.district, address.detailAddress];
}

#pragma mark- 前往地址
- (void)chooseAddress {
    
    BaseWeakSelf;
    
    ZHAddressChooseVC *chooseVC = [[ZHAddressChooseVC alloc] init];
    //    chooseVC.addressRoom = self.addressRoom;
    chooseVC.selectedAddrCode = self.currentAddress.code;
    
    chooseVC.chooseAddress = ^(ZHReceivingAddress *addr){
        
        weakSelf.currentAddress = addr;
        [weakSelf setHeaderAddress:addr];
        
    };
    
    [self.navigationController pushViewController:chooseVC animated:YES];
    
    
}

#pragma mark- 原来无地址，现在添加地址
- (void)addAddress {
    
    BaseWeakSelf;
    
    ZHAddAddressVC *addressVC = [[ZHAddAddressVC alloc] init];
    
    addressVC.addressType = AddressTypeAdd;
    
    addressVC.addAddress = ^(ZHReceivingAddress *address){
        
        //原来无地址, 现在又地址
        weakSelf.currentAddress = address;
        [weakSelf setHeaderAddress:address];
        [weakSelf.addressRoom addObject:address];
        
    };
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *goodInfoCell = @"GoodInfoCellId";
    GoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodInfoCell];
    if (!cell) {
        
        cell = [[GoodInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodInfoCell];
    }
    
    if (self.type == IMBuyTypeSingle) {
        
        cell.goods = self.good;
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    
    view.backgroundColor = kWhiteColor;
    
    //配送方式
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor whiteColor]
                                                 font:Font(14)
                                            textColor:kTextColor];
    [view addSubview:textLbl];
    textLbl.text = @"配送方式";
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(@(0));
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    //快递
    UILabel *freightLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentRight
                                      backgroundColor:kClearColor
                                                 font:Font(14)
                                            textColor:kTextColor];
    [view addSubview:freightLbl];
    freightLbl.text = @"快递";
    
    [freightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@(0));
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 10)];
    
    line.backgroundColor = kBackgroundColor;
    
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 96;
}

#pragma mark- 设置没有收货地址的UI
- (void)setNOAddressUI {
    
    //  [self.headerView.subviews performSelector:@selector(removeFromSuperview)];
    
    UIView *addressView = self.headerView;
    [self.view addSubview:addressView];
    //    addressView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *noAddressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 35, 35)];
    [addressView addSubview:noAddressImageV];
    
    //-==-//
    noAddressImageV.centerX = kScreenWidth/2.0;
    noAddressImageV.image = [UIImage imageNamed:@"添加收获地址"];
    
    //btn
    UIButton *addBtn = [UIButton buttonWithTitle:@"+ 添加" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:11.0 cornerRadius:3];
    
    addBtn.frame = CGRectMake(kScreenWidth/2.0 + 25, noAddressImageV.yy + 9, 58, 21);
    
    [addBtn setEnlargeEdge:20];
    
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [addBtn drawAroundLine:4 lineSpacing:2 lineColor:kAppCustomMainColor];
    
    [addressView addSubview:addBtn];

    //
    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth/2.0 + 3, addBtn.height) textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
    [addressView addSubview:hintLbl];
    hintLbl.text = @"还没有收货地址";
    hintLbl.centerY = addBtn.centerY;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 2)];
    [_headerView addSubview:line];
    line.y = _headerView.height - 2;
    line.image = [UIImage imageNamed:@"address_line"];
    
}


@end
