//
//  GoodDetailHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodDetailHeaderView.h"


@interface GoodDetailHeaderView()

//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//商品价格
@property (nonatomic, strong) UILabel *priceLabel;
//原价
@property (nonatomic, strong) UILabel *marketPriceLabel;
//运费
@property (nonatomic, strong) UILabel *freightLbl;
//地址
@property (nonatomic, strong) UIButton *addressBtn;

@end

@implementation GoodDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    //名称
    self.nameLabel = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(18.0) textColor:kTextColor];
    self.nameLabel.height = [[UIFont secondFont] lineHeight];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_lessThanOrEqualTo(45);
        make.right.mas_equalTo(10);
    }];
    
    //价格
    self.priceLabel = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:Font(25.0)
                                    textColor:kThemeColor];
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(15);
        make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(kFontHeight(25.0));
        
    }];
    //原价
    self.marketPriceLabel = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor clearColor]
                                               font:Font(14.0)
                                          textColor:kTextColor];
    [self addSubview:self.marketPriceLabel];
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.priceLabel.mas_top).mas_equalTo(0);
        make.left.mas_equalTo(self.priceLabel.mas_right).mas_equalTo(17);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(kFontHeight(25.0));
        
    }];
    
    //运费
    self.freightLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor clearColor]
                                               font:Font(14.0)
                                          textColor:kTextColor];
    [self addSubview:self.freightLbl];
    [self.freightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.priceLabel.mas_top).mas_equalTo(0);
        make.left.mas_equalTo(self.marketPriceLabel.mas_right).mas_equalTo(6);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(kFontHeight(25.0));
        
    }];
    
    //地址
    self.addressBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor2 backgroundColor:kBackgroundColor titleFont:11.0 cornerRadius:11.5];
    
    [self.addressBtn setImage:kImage(@"address") forState:UIControlStateNormal];
    
    [self addSubview:self.addressBtn];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.nameLabel.mas_left).mas_equalTo(0);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(23);
        
    }];
    
    UIImageView *rightIV = [[UIImageView alloc] initWithImage:kImage(@"进入")];
    
    rightIV.tag = 2000;
    
    [self.addressBtn addSubview:rightIV];
    
    //浏览量
    self.readLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:14.0];
    
    self.readLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.readLbl];
    [self.readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(14.0);
    }];
}

#pragma mark - Setting
- (void)setGood:(GoodModel *)good {
    
    _good = good;
    
    _nameLabel.text = _good.name;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", [_good.price convertToSimpleRealMoney]];
    
    _marketPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [_good.originalPrice convertToSimpleRealMoney]];
    
    _freightLbl.text = [NSString stringWithFormat:@"运费￥%@", [_good.yunfei convertToSimpleRealMoney]];
    
    NSString *addressStr = [NSString stringWithFormat:@"%@ | %@", _good.city, _good.area];
    //计算地址宽度
    CGFloat addressStrW = [NSString getWidthWithString:addressStr font:11.0];
    
    CGFloat addressW = 10 + 9 + 6 + addressStrW + 10 + 5 + 14;
    
    [_addressBtn setTitle:addressStr forState:UIControlStateNormal];
    
    [_addressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(addressW);
        
    }];
    [_addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 21 + 15, 0, 0)];
    [_addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -_addressBtn.imageView.frame.size.width - _addressBtn.frame.size.width + _addressBtn.titleLabel.intrinsicContentSize.width + 15 + 15, 0, 0)];
    
    UIImageView *rightIV = (UIImageView *)[self viewWithTag:2000];
    
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-14);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
        
    }];
}

@end
