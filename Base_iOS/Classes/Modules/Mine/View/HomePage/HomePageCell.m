//
//  HomePageCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomePageCell.h"

@interface HomePageCell ()

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
//@property (nonatomic, strong) UILabel *marketPriceLabel;
//地址
@property (nonatomic, strong) UIButton *addressBtn;
//折扣
@property (nonatomic, strong) UILabel *couponLbl;
//商品状态
@property (nonatomic, strong) UIImageView *statusIV;

@end

@implementation HomePageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        CGFloat imgW = (kScreenWidth - 10)/2.0;
        
        self.goodIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgW)];
        
        self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
        self.goodIV.clipsToBounds = YES;
        
        [self addSubview:self.goodIV];
        
        //名称
        self.nameLabel = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(14.0) textColor:kTextColor];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.goodIV.mas_bottom).offset(10);
            make.width.equalTo(@(imgW - 20));
        }];
        
        //商品状态
        self.statusIV = [[UIImageView alloc] init];
        
        [self addSubview:self.statusIV];
        [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.goodIV.mas_bottom).offset(10);
            
        }];
        
        //价格
        self.priceLabel = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:Font(17)
                                        textColor:kThemeColor];
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(8);
            make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(-2);
            make.width.mas_lessThanOrEqualTo(200);
            
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
            make.top.equalTo(self.priceLabel.mas_top);
            make.width.mas_lessThanOrEqualTo(200);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(self.priceLabel.mas_right).mas_equalTo(6);
            
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
            
            make.left.equalTo(self.fromLbl.mas_right).offset(6);
            make.top.equalTo(self.priceLabel.mas_top);
            make.width.equalTo(@32);
            make.height.mas_equalTo(18);
            
        }];
        
        //地址
        self.addressBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:11.0];
        
        [self.addressBtn setImage:kImage(@"address") forState:UIControlStateNormal];
        
        [self addSubview:self.addressBtn];
        [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
            make.width.equalTo(@(imgW - 20));
            
        }];
        
        //
//        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = kLineColor;
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.mas_equalTo(@0.5);
//        }];
        
        
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
    
    if (_isCoupon) {
        
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
    
//    _marketPriceLabel.text = [NSString stringWithFormat:@"原价: ￥%@", [_goodModel.originalPrice convertToSimpleRealMoney]];
    
    [_addressBtn setTitle:[NSString stringWithFormat:@"%@ | %@", _goodModel.city, _goodModel.area] forState:UIControlStateNormal];
    
    [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 21, 0, 0)];
    [_addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 15, 0, 0)];
}

@end
