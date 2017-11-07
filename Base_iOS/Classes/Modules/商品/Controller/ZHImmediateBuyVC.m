//
//  ZHImmediateBuyVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHImmediateBuyVC.h"

#import "AppConfig.h"

#import "ZHAddressChooseVC.h"
#import "ZHNewPayVC.h"
#import "ZHAddAddressVC.h"
#import "ZHGoodsDetailVC.h"
#import "ZHShoppingCartVC.h"

#import "ZHOrderGoodsCell.h"

#import "TLCurrencyHelper.h"
#import "BaseAddressChooseView.h"
#import "ZHReceivingAddress.h"

#import "ZHCartManager.h"

#import "ZHCartGoodsModel.h"

//#import "IQKeyboardManager.h"


@interface ZHImmediateBuyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel * totalPriceLbl;
//
//@property (nonatomic,strong) UILabel *nameLbl;
//@property (nonatomic,strong) UILabel *mobileLbl;
//@property (nonatomic,strong) UILabel *addressLbl;

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIImageView *arrowIV;
@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) TLTextField *enjoinTf;

@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;
@property (nonatomic,strong) ZHReceivingAddress *currentAddress;
@property (nonatomic,strong) BaseAddressChooseView *chooseView;

@end

@implementation ZHImmediateBuyVC

- (BaseAddressChooseView *)chooseView {
    
    if (!_chooseView) {
        
        __weak typeof(self) weakself = self;
        //头部有个底 可以添加，有地址时的ui和无地址时的ui
        _chooseView = [[BaseAddressChooseView alloc] initWithFrame:self.headerView.bounds];
        _chooseView.chooseAddress = ^(){
            
            [weakself chooseAddress];
        };
    }
    return _chooseView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //根据有无地址创建UI
    [self getAddress];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"确认订单";
    
    if (self.type == ZHIMBuyTypeSingle) { //---单买
        
        if (!self.goodsRoom) {
            
            NSLog(@"请传递购物模型");
            return;
        }
        
        GoodModel *goods = self.goodsRoom[0];
        
        NSString *totalPrice = [NSString stringWithFormat:@"%ld", [goods.currentParameterPriceRMB integerValue]*goods.currentCount];
        
        self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%@", [totalPrice convertToRealMoney]];
        
    } else {
    
        
         ZHCartGoodsModel*cartModel = self.cartsRoom[0];
        
        NSString *totalPrice = [NSString stringWithFormat:@"%ld", [cartModel.productSpecs.price1 integerValue]*cartModel.quantity];

        self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%@", [totalPrice convertToRealMoney]];
    }
    
    
}

#pragma mark- 立即购买行为
- (void)buyAction {
    
    if (!self.currentAddress) {
        
        [TLAlert alertWithInfo:@"请选择收货地址"];
        return;
    }
    
    BaseWeakSelf;
    //
    if (self.type == ZHIMBuyTypeSingle && self.goodsRoom) { //普通商品购买
        
        //单个购买
        GoodModel *goods = self.goodsRoom[0];
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808050";
        http.parameters[@"productSpecsCode"] = self.goodsRoom[0].selectedParameter.code;
        
        http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",goods.currentCount];
        
        http.parameters[@"pojo"] = [NSMutableDictionary dictionary];
        http.parameters[@"pojo"][@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"pojo"][@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"pojo"][@"reMobile"] = self.currentAddress.mobile;
        
        http.parameters[@"pojo"][@"applyUser"] = [TLUser user].userId;
        http.parameters[@"pojo"][@"companyCode"] = [AppConfig config].companyCode;
        http.parameters[@"pojo"][@"systemCode"] = [AppConfig config].systemCode;
        
        //根据收货地址
        http.parameters[@"token"] = [TLUser user].token;
        
        NSString *note = [self.enjoinTf.text valid] ? self.enjoinTf.text: @"无";

        http.parameters[@"pojo"][@"applyNote"] = note;
        
        [http postWithSuccess:^(id responseObject) {
            
            //订单编号
            NSString *orderCode = responseObject[@"data"];
            
            //商品购买
            ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
            payVC.goodsCodeList = @[orderCode];
            NSNumber *rmb = self.goodsRoom[0].currentParameterPriceRMB;
            payVC.rmbAmount = @([rmb longLongValue]*self.goodsRoom[0].currentCount); //把人民币传过去
            
            
            GoodModel *goods = self.goodsRoom[0];
            
            //不加邮费的价格
            payVC.amoutAttr = [TLCurrencyHelper calculatePriceWithQBB:goods.currentParameterPriceQBB
                                                                  GWB:goods.currentParameterPriceGWB
                                                                  RMB:goods.currentParameterPriceRMB
                                                                count:goods.currentCount];
            //加邮费的价格
//            payVC.amoutAttrAddPostage = [TLCurrencyHelper calculatePriceWithQBB:goods.currentParameterPriceQBB
//                                                                            GWB:goods.currentParameterPriceGWB
//                                                                            RMB:goods.currentParameterPriceRMB
//                                                                          count:goods.count addPostageRmb:self.postage];
            //邮费
            payVC.postage = self.postage;
            
            
            payVC.paySucces = ^(){
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[ZHGoodsDetailVC class]]) {
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
            };
            payVC.type = ZHPayViewCtrlTypeNewGoods;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        return;
        
    } else if (self.type == ZHIMBuyTypeAll && self.cartsRoom) {
    
        //购物车购买
        ZHCartGoodsModel *cartModel = self.cartsRoom[0];
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808051";
        http.parameters[@"cartCodeList"] = @[cartModel.code];
        
        http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",cartModel.quantity];
        
        http.parameters[@"pojo"] = [NSMutableDictionary dictionary];
        http.parameters[@"pojo"][@"receiver"] = self.currentAddress.addressee;
        http.parameters[@"pojo"][@"reAddress"] = self.currentAddress.totalAddress;
        http.parameters[@"pojo"][@"reMobile"] = self.currentAddress.mobile;
        
        http.parameters[@"pojo"][@"applyUser"] = [TLUser user].userId;
        http.parameters[@"pojo"][@"companyCode"] = [AppConfig config].companyCode;
        http.parameters[@"pojo"][@"systemCode"] = [AppConfig config].systemCode;
        
        //根据收货地址
        http.parameters[@"token"] = [TLUser user].token;
        if ([self.enjoinTf.text valid]) {
            
            http.parameters[@"pojo"][@"applyNote"] = self.enjoinTf.text;
        }
        
        [http postWithSuccess:^(id responseObject) {
            
            //订单编号
            NSString *orderCode = responseObject[@"data"];
            
            //商品购买
            ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
            payVC.type = ZHPayViewCtrlTypeNewGoods;

            payVC.goodsCodeList = @[orderCode];
            NSNumber *rmb = self.cartsRoom[0].productSpecs.price1;
            payVC.rmbAmount = @([rmb longLongValue]*cartModel.quantity); //把人民币传过去
            
            //不加邮费的价格
            payVC.amoutAttr = [TLCurrencyHelper calculatePriceWithQBB:cartModel.currentParameterPriceQBB
                                                                  GWB:cartModel.currentParameterPriceGWB
                                                                  RMB:cartModel.productSpecs.price1
                                                                count:cartModel.currentCount];
            //加邮费的价格
            //            payVC.amoutAttrAddPostage = [TLCurrencyHelper calculatePriceWithQBB:goods.currentParameterPriceQBB
            //                                                                            GWB:goods.currentParameterPriceGWB
            //                                                                            RMB:goods.currentParameterPriceRMB
            //                                                                          count:goods.count addPostageRmb:self.postage];
            //邮费
            payVC.postage = self.postage;
            
            
            payVC.paySucces = ^(){
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[ZHShoppingCartVC class]]) {
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
            };
            
            [self.navigationController pushViewController:payVC animated:YES];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        return;
        
    }
    
}



- (void)getAddress {
    
    //查询是否有收货地址
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805165";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
    [http postWithSuccess:^(id responseObject) {
        
        //
        
        self.buyBtn.y = self.tableV.yy;
        
        //添加
        [self.view addSubview:self.tableV];
        //购买按钮
        [self.view addSubview:self.buyBtn];
        
        NSArray *adderssRoom = responseObject[@"data"];
        if (adderssRoom.count > 0 ) { //有收获地址
            
            self.addressRoom = [ZHReceivingAddress mj_objectArrayWithKeyValuesArray:adderssRoom];
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
    self.chooseView.addressLbl.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",address.province,address.city, address.district, address.detailAddress];
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
    
    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    address.addAddress = ^(ZHReceivingAddress *address){
        
        //原来无地址, 现在又地址
        weakSelf.currentAddress = address;
        [weakSelf setHeaderAddress:address];
        [weakSelf.addressRoom addObject:address];
        
    };
    [self.navigationController pushViewController:address animated:YES];
    
}

- (UITableView *)tableV{
    
    if (!_tableV) {
        
        //无收货地址
        TLTableView *tableView = [TLTableView groupTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) delegate:self dataSource:self];
        tableView.tableHeaderView = self.headerView;
        tableView.tableFooterView = [self footerView];
        _tableV = tableView;
    }
    return _tableV;
    
}

- (UIButton *)buyBtn {
    
    if (!_buyBtn) {
        
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49) title:@"立即购买" backgroundColor:kAppCustomMainColor];
        [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _buyBtn;
    
}

- (UILabel *)totalPriceLbl {
    
    if (!_totalPriceLbl) {
        _totalPriceLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(16)
                                       textColor:[UIColor zh_themeColor]];
    }
    
    return _totalPriceLbl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

#pragma datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCell = @"ZHOrderGoodsCellId";
    ZHOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCell];
    if (!cell) {
        
        cell = [[ZHOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCell];
    }
    
    if (self.type == ZHIMBuyTypeSingle) {
        
        cell.goods = self.goodsRoom[indexPath.row];

    } else {
    
        cell.cartGoodsModel = self.cartsRoom[indexPath.row];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 96;
}

- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    footerView.backgroundColor = [UIColor whiteColor];
    TLTextField *tf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) leftTitle:@"买家嘱咐：" titleWidth:100 placeholder:@"对本次交易的说明"];
    [footerView addSubview:tf];
    self.enjoinTf = tf;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tf.yy + 1, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor zh_lineColor];
    [footerView addSubview:line];
    
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor whiteColor]
                                                 font:FONT(14)
                                            textColor:[UIColor zh_textColor]];
    [footerView addSubview:hintLbl];
    hintLbl.text = @"应付金额：";
    
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(footerView.mas_left).offset(15);
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@(45));
        make.width.equalTo(@(75));
        
    }];
    
    //
    [footerView addSubview:self.totalPriceLbl];
    [self.totalPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintLbl.mas_right).offset(8);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(footerView.mas_bottom);
        
    }];
    
    return footerView;
    
}

//#pragma mark- 有收获地址时的头部UI
- (void)setHaveAddressUI {
    
    if (self.headerView.subviews.count > 0) {
        
        [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    }
    [self.headerView addSubview:self.chooseView];
    
}

//
- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 75)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
    
}

#pragma mark- 设置没有收货地址的UI
- (void)setNOAddressUI {
    
    //  [self.headerView.subviews performSelector:@selector(removeFromSuperview)];
    
    UIView *addressView = self.headerView;
    self.tableV.tableHeaderView = addressView;
//    [self.view addSubview:addressView];
    //    addressView.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *noAddressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 35, 35)];
//    [addressView addSubview:noAddressImageV];
//    
//    //-==-//
//    noAddressImageV.centerX = kScreenWidth/2.0;
//    noAddressImageV.image = [UIImage imageNamed:@"添加收获地址"];
    
    //btn
    UIButton *addBtn = [UIButton buttonWithTitle:@"+ 添加收货地址" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:14.0 cornerRadius:5];

    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
        make.centerY.mas_equalTo(0);
        
    }];
    
    //
//    UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth/2.0 + 3, addBtn.height) textAligment:NSTextAlignmentRight
//                               backgroundColor:[UIColor whiteColor]
//                                          font:FONT(13)
//                                     textColor:[UIColor zh_textColor]];
//    [addressView addSubview:hintLbl];
//    hintLbl.text = @"还没有收货地址";
//    hintLbl.centerY = addBtn.centerY;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 2)];
    [_headerView addSubview:line];
    line.y = _headerView.height - 2;
    line.image = [UIImage imageNamed:@"address_line"];
    
}

@end
