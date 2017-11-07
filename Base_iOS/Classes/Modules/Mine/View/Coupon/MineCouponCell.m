//
//  MineCouponCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineCouponCell.h"

@interface MineCouponCell ()

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UILabel *moneyLbl;    //优惠额度

@property (nonatomic, strong) UILabel *amountLbl;   //限制条件

@property (nonatomic, strong) UILabel *timeLbl;     //截止日期

@end

@implementation MineCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
    
}

- (void)initSubviews {

    self.backgroundColor = kClearColor;
    
    CGFloat leftMargin = 15;
    
    CGFloat bgViewH = 90;
    
    UIImageView *bgView = [[UIImageView alloc] init];
    
    bgView.frame = CGRectMake(leftMargin, 10, kScreenWidth - 2*leftMargin, bgViewH);
    
    [self addSubview:bgView];
    
    self.bgView = bgView;
    
    self.moneyLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:27];
    
    self.moneyLbl.frame = CGRectMake(0, bgViewH/2.0 - 20, 150, 28);
    
    self.moneyLbl.textAlignment = NSTextAlignmentCenter;
    
    self.moneyLbl.centerX = kWidth(100/2.0);
    
    [bgView addSubview:self.moneyLbl];
    
    UILabel *textLbl = [UILabel labelWithText:@"优惠券" textColor:kWhiteColor textFont:12.0];
    
    textLbl.frame = CGRectMake(0, self.moneyLbl.yy + 3, 40, 13);
    
    textLbl.textAlignment = NSTextAlignmentCenter;

    textLbl.centerX = self.moneyLbl.centerX;

    [bgView addSubview:textLbl];
    
    self.amountLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:12.0];
    
    self.amountLbl.frame = CGRectMake(kWidth(127), bgViewH/2.0 - 13, 200, 13);
    
    [bgView addSubview:self.amountLbl];
    
    self.timeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:12.0];
    
    self.timeLbl.frame = CGRectMake(kWidth(127), self.amountLbl.yy + 10, 200, 13);
    
    [bgView addSubview:self.timeLbl];
}

- (void)setCoupon:(CouponModel *)coupon {

    _coupon = coupon;
    
    NSString *imgStr = [_coupon.status isEqualToString:@"0"] ? @"优惠券": @"优惠券不可用";
    
    UIColor *color = [_coupon.status isEqualToString:@"0"] ? kTextColor2: kTextColor4;

    self.bgView.image = kImage(imgStr);
    
    self.amountLbl.textColor = color;
    
    self.timeLbl.textColor = color;
    
    [_moneyLbl labelWithString:[NSString stringWithFormat:@"￥%@", [_coupon.parValue convertToSimpleRealMoney]] title:@"￥" font:Font(15) color:kWhiteColor];
    
    _amountLbl.text = [NSString stringWithFormat:@"减免%@元", [_coupon.parValue convertToSimpleRealMoney]];
    
    _timeLbl.text = [NSString stringWithFormat:@"截止日期: %@", [_coupon.endDatetime convertDate]];
    
    ;
}

@end
