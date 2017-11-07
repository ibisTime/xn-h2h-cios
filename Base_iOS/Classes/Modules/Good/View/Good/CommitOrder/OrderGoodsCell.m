//
//  OrderGoodsCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderGoodsCell.h"

@interface OrderGoodsCell ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;
//商品价格
@property (nonatomic,strong) UILabel *priceLbl;
//数目
@property (nonatomic,strong) UILabel *numLbl;
//总价
@property (nonatomic, strong) UILabel *totalAmountLbl;
//已卖出
@property (nonatomic, strong) UIImageView *statusIV;

@end

@implementation OrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.coverImageV = [[UIImageView alloc] init];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.masksToBounds  = YES;
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
        
        //商品状态
        self.statusIV = [[UIImageView alloc] init];
        
        [self addSubview:self.statusIV];
        [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(13.0)
                                      textColor:kThemeColor];
        [self addSubview:self.priceLbl];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(kFontHeight(13.0));
            
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
        
        //数量
        self.numLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:kClearColor
                                         font:Font(13)
                                    textColor:kTextColor];
        
        [self addSubview:self.numLbl];
        [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(kFontHeight(13.0));
            make.top.mas_equalTo(self.priceLbl.mas_bottom).mas_equalTo(6);
        }];
        
        //总价
        self.totalAmountLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight backgroundColor:kClearColor font:Font(14.0) textColor:kTextColor];
        
        [self addSubview:self.totalAmountLbl];
        [self.totalAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(250);
            make.height.mas_equalTo(kFontHeight(14.0));
            make.bottom.mas_equalTo(-15);
            
        }];
        
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

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    OrderDetailModel *product = _order.productOrderList[0];
    
    NSString *urlStr = [product.productPic componentsSeparatedByString:@"||"][0];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    NSString *imgStr = @"";
    
    if ([_order.status isEqualToString:@"5"]) {
        
        imgStr = @"已卖出";
        
    }
    
    _statusIV.image = kImage(imgStr);
    
    //
    self.nameLbl.text = product.productName;
    
    //
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_order.amount1 convertToSimpleRealMoney]];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[product.quantity stringValue]];
    
    //
    
    //总计=(商品总额+运费)*折扣
    
    CGFloat totalAmount = [_order.amount1 doubleValue] + [_order.yunfei doubleValue];
    
    NSString *amountStr = [NSString stringWithFormat:@"￥%@", [@(totalAmount) convertToSimpleRealMoney]];
    
    [_totalAmountLbl labelWithString:[NSString stringWithFormat:@"总计: %@", amountStr] title:amountStr font:Font(15.0) color:kThemeColor];
}

+ (CGFloat)rowHeight {
    
    return 96;
}

@end
