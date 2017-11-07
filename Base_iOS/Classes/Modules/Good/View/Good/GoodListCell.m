//
//  GoodListCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/15.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "GoodListCell.h"

@interface GoodListCell ()

//缩略图
@property (nonatomic, strong) UIImageView *goodIV;
//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//来自哪里
@property (nonatomic, strong) UILabel *fromLbl;
//是否全新
@property (nonatomic, strong) UILabel *isNewLbl;
//商品价格
@property (nonatomic, strong) UILabel *priceLabel;
//原价
@property (nonatomic, strong) UILabel *marketPriceLabel;
//地址
@property (nonatomic, strong) UIButton *addressBtn;
//折扣
@property (nonatomic, strong) UILabel *couponLbl;
//商品状态
@property (nonatomic, strong) UIImageView *statusIV;

@end;

@implementation GoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goodIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 120, 120)];
        
        self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
        self.goodIV.clipsToBounds = YES;
        
        [self addSubview:self.goodIV];
        
        //名称
        self.nameLabel = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(14.0) textColor:kTextColor];
                self.nameLabel.numberOfLines = 0;
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.mas_equalTo(self.goodIV.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(17);
            make.height.mas_lessThanOrEqualTo(40);
            make.right.mas_equalTo(10);
        }];
        
        //商品状态
        self.statusIV = [[UIImageView alloc] init];
        
        [self addSubview:self.statusIV];
        [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.goodIV.mas_bottom).offset(-5);
            
        }];
        
        //来自哪里
        self.fromLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentCenter
                             backgroundColor:[UIColor clearColor]
                                        font:Font(11)
                                   textColor:kAppCustomMainColor];
        
        self.fromLbl.layer.cornerRadius = 3;
        self.fromLbl.clipsToBounds = YES;
        self.fromLbl.layer.borderColor = kAppCustomMainColor.CGColor;
        self.fromLbl.layer.borderWidth = 1;
        
        [self addSubview:self.fromLbl];
        [self.fromLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(11);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(0);
            
        }];
        
        //全新
        self.isNewLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:Font(11)
                                     textColor:kThemeColor];
        self.isNewLbl.layer.cornerRadius = 3;
        self.isNewLbl.clipsToBounds = YES;
        
        self.isNewLbl.layer.borderColor = kThemeColor.CGColor;
        self.isNewLbl.layer.borderWidth = 1;
        
        self.isNewLbl.text = @"全新";
        
        [self addSubview:self.isNewLbl];
        [self.isNewLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(11);
            make.width.equalTo(@32);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(self.fromLbl.mas_right).mas_equalTo(10);
            
        }];
        
        //价格
        self.priceLabel = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(17)
                                      textColor:kThemeColor];
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.fromLbl.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(-2);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(kFontHeight(17.0));
            
        }];
        //原价
        self.marketPriceLabel = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:Font(11)
                                        textColor:kTextColor];
        [self addSubview:self.marketPriceLabel];
        [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.fromLbl.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(self.priceLabel.mas_right).mas_equalTo(17);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(kFontHeight(17.0));
            
        }];
        
        //地址
        self.addressBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:11.0];
        
        [self.addressBtn setImage:kImage(@"address") forState:UIControlStateNormal];
        
        [self addSubview:self.addressBtn];
        [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(0);
            make.top.mas_equalTo(self.priceLabel.mas_bottom).mas_equalTo(13);
            make.width.mas_equalTo(200);
            make.height.mas_lessThanOrEqualTo(20);
            
        }];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

- (UILabel *)couponLbl {
    
    if (!_couponLbl) {
        
        UIImageView *iconIV = [[UIImageView alloc] init];
        
        iconIV.image = kImage(@"折扣");
        
        [self addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.goodIV.mas_top);
            make.left.equalTo(self.goodIV.mas_left);
            make.width.equalTo(@33);
            make.height.equalTo(@27);
            
        }];
        
        _couponLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:11.0];
        
        [iconIV addSubview:_couponLbl];
        [_couponLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(iconIV.mas_top).offset(5);
            
        }];
    }
    
    return _couponLbl;
}
+ (CGFloat)rowHeight {
    
    return 150;
}

- (void)setGoodModel:(GoodModel *)goodModel {

    _goodModel = goodModel;
    
//    CDGoodsParameterModel *productInfo = _goodModel.productSpecsList[0];
    //封面
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:_goodModel.pics[0]] placeholderImage:GOOD_PLACEHOLDER_SMALL];

    if (_isCoupon && [_goodModel.activityType isEqualToString:@"1"]) {
        
        self.couponLbl.text = [NSString stringWithFormat:@"%lg折", [_goodModel.discount doubleValue]*10];

    }
    
    NSString *imgStr = @"";
    
    if ([_goodModel.status isEqualToString:@"4"]) {
        
        imgStr = @"已卖出";
        
    } else if ([_goodModel.status isEqualToString:@"5"]) {
        
        imgStr = @"已下架";
    }
    
    _statusIV.image = kImage(imgStr);
    
    _nameLabel.text = _goodModel.name;
    
    _fromLbl.text = [NSString stringWithFormat:@"来自%@", _goodModel.typeName];
    //更新fromLbl宽度
    CGFloat fromW = _fromLbl.text.length*11 + 10;

    [_fromLbl mas_updateConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(fromW);
    }];
    
    _isNewLbl.hidden = [_goodModel.isNew isEqualToString:@"1"] ? NO: YES;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", [_goodModel.price convertToSimpleRealMoney]];
    
    _marketPriceLabel.text = [NSString stringWithFormat:@"原价: ￥%@", [_goodModel.originalPrice convertToSimpleRealMoney]];
    
    [_addressBtn setTitle:[NSString stringWithFormat:@"%@ | %@", _goodModel.city, _goodModel.area] forState:UIControlStateNormal];
    
    [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 21, 0, 0)];
    [_addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 15, 0, 0)];
}

@end
