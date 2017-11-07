//
//  GoodInfoCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodInfoCell.h"

@interface GoodInfoCell ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;
//价格
@property (nonatomic,strong) UILabel *priceLbl;
//原价
@property (nonatomic, strong) UILabel *originPriceLbl;
//横线
@property (nonatomic, strong) UIView *hLine;

@end

@implementation GoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.coverImageV = [[UIImageView alloc] init];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverImageV];
        [self.coverImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(80);
            make.bottom.mas_equalTo(-10);
            
        }];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(15.0) textColor:kTextColor];
        
        self.nameLbl.numberOfLines = 0;
        
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.coverImageV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_lessThanOrEqualTo(MAXFLOAT);
            
        }];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(17.0)
                                      textColor:kThemeColor];
        
        [self addSubview:self.priceLbl];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.nameLbl.mas_left).mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(kFontHeight(17.0));
            
        }];
        
        //原价
        self.originPriceLbl = [UILabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor clearColor]
                                                 font:Font(14.0)
                                            textColor:kTextColor2];
        [self addSubview:self.originPriceLbl];
        [self.originPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.priceLbl.mas_right).mas_equalTo(15);
            make.top.mas_equalTo(self.priceLbl.mas_top).mas_equalTo(0);
            make.bottom.mas_equalTo(self.priceLbl.mas_bottom).mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(150);
            
        }];
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        //横线
        self.hLine = [[UIView alloc] init];
        
        self.hLine.backgroundColor = kTextColor2;
        
        [self addSubview:self.hLine];
    }
    return self;
}

- (void)setGoods:(GoodModel *)goods {
    
    _goods = goods;
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:_goods.pics[0]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    //
    self.nameLbl.text = _goods.name;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_goods.price convertToSimpleRealMoney]];
    
    //
    self.originPriceLbl.text = [NSString stringWithFormat:@"￥%@",[_goods.originalPrice convertToSimpleRealMoney]];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.originPriceLbl.mas_left).mas_equalTo(-2);
        make.right.mas_equalTo(self.originPriceLbl.mas_right).mas_equalTo(2);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.originPriceLbl.mas_centerY).mas_equalTo(0);
    }];
    
}

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    OrderDetailModel *detailModel = _order.productOrderList[0];
    
    NSDictionary *product = detailModel.product;
    
    NSString *urlStr = product[@"advPic"];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    //
    self.nameLbl.text = product[@"name"];
    
    //
    self.priceLbl.text = _moneyType == MoneyTypeRMB ? [TLCurrencyHelper totalPriceWithQBB:detailModel.price3 GWB:detailModel.price2 RMB:detailModel.price1] : [NSString stringWithFormat:@"%@ 积分", [detailModel.price1 convertToRealMoney]];
    
    //
}

+ (CGFloat)rowHeight {
    
    return 96;
}

@end
