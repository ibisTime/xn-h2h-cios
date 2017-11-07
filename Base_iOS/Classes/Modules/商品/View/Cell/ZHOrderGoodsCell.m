//
//  ZHOrderGoodsCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderGoodsCell.h"
#import "ZHOrderModel.h"

@interface ZHOrderGoodsCell()

@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic,strong) UILabel *numLbl; //数目



@end

@implementation ZHOrderGoodsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 13, 15, kScreenWidth - self.coverImageV.xx - 13 - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        
        //价格
        
        self.priceLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, [FONT(13) lineHeight])
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(13)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.priceLbl];
        
        //广告语
        self.numLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.priceLbl.yy + 8, self.nameLbl.width, [FONT(11) lineHeight])
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor clearColor]
                                        font:FONT(11)
                                   textColor:[UIColor zh_textColor2]];
        [self addSubview:self.numLbl];
        
        //评价的按钮
        CGFloat w = 50;
        UIButton *pjBtn = [UIButton zhBtnWithFrame:CGRectMake(kScreenWidth - 10 - w, self.priceLbl.yy + 5, w, 25) title:@"评价"];
//        [self addSubview:pjBtn];
        [pjBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
 
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}


//- (void)commentAction {
//
//    if (self.comment) {
//        
//        self.comment(self.cartGoods.code);
//        
//    }
//
//}

//- (void)setCartGoods:(ZHCartGoodsModel *)cartGoods {
//
//    _cartGoods = cartGoods;
//    NSString *urlStr = _cartGoods.product.advPic;
//    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    //
//    self.nameLbl.text = _cartGoods.product.name;
//    self.priceLbl.text = [TLCurrencyHelper totalPriceWithQBB:_cartGoods.qbb GWB:_cartGoods.gwb RMB:_cartGoods.rmb];
//    self.numLbl.text = [NSString stringWithFormat:@"X%@",_cartGoods.quantity];
//
//}

- (void)setGoods:(GoodModel *)goods {

    _goods = goods;
    NSString *urlStr = _goods.advPic;
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = _goods.name;
    self.priceLbl.text = _moneyType == MoneyTypeRMB ? _goods.totalPrice : [NSString stringWithFormat:@"%@ 积分", [_goods.selectedParameter.price1 convertToRealMoney]];;
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %ld",_goods.currentCount];
    
}



- (void)setOrder:(ZHOrderModel *)order {

    _order = order;
    
    ZHOrderDetailModel *detailModel = _order.productOrderList[0];
    
    NSDictionary *product = detailModel.product;
    
    NSString *urlStr = product[@"advPic"];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = product[@"name"];
    
    //
    self.priceLbl.text = _moneyType == MoneyTypeRMB ? [TLCurrencyHelper totalPriceWithQBB:detailModel.price3 GWB:detailModel.price2 RMB:detailModel.price1] : [NSString stringWithFormat:@"%@ 积分", [detailModel.price1 convertToRealMoney]];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[detailModel.quantity stringValue]];
    
    //
}

- (void)setCartGoodsModel:(ZHCartGoodsModel *)cartGoodsModel {

    _cartGoodsModel = cartGoodsModel;
    
    CartProduct *product = _cartGoodsModel.product;
    
    NSString *urlStr = product.advPic;
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = product.name;
    
    //
    self.priceLbl.text = _moneyType == MoneyTypeRMB ? [NSString stringWithFormat:@"￥%@", [_cartGoodsModel.productSpecs.price1 convertToRealMoney]] : [NSString stringWithFormat:@"%@ 积分", [_cartGoodsModel.productSpecs.price1 convertToRealMoney]];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"x %ld",_cartGoodsModel.quantity];
    
}

//- (void)setOrderGoods:(GoodModel *)orderGoods {
//
//    _orderGoods = orderGoods;
//    
//    NSString *urlStr = _orderGoods.advPic;
//    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertThumbnailImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
//    //
//    self.nameLbl.text = _orderGoods.name;
//    
//    self.priceLbl.text = [TLCurrencyHelper totalPriceWithQBB:_orderGoods.currentParameterPriceQBB GWB:_orderGoods.currentParameterPriceGWB RMB:_orderGoods.currentParameterPriceRMB];
//    
//    self.numLbl.text = [NSString stringWithFormat:@"X%@",_orderGoods.quantity];
//    
//}

+ (CGFloat)rowHeight {

    return 96;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
