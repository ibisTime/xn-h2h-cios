//
//  CouponCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponCell.h"

@interface CouponCell ()

@end

@implementation CouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //选择按钮
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"地址-未选中"] forState:UIControlStateNormal];
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"支付选中"] forState:UIControlStateSelected];
        self.selectedBtn.userInteractionEnabled = NO;
        
        [self addSubview:self.selectedBtn];
        
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
            
        }];
        //text
        self.textLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:[UIFont secondFont]
                                     textColor:[UIColor textColor]];
        [self addSubview:self.textLbl];
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.height.equalTo(self);
            make.left.equalTo(@(15));
            make.right.equalTo(self.selectedBtn.mas_left);
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

- (void)setCoupon:(CouponModel *)coupon {
    
    _coupon = coupon;
    
    _textLbl.text = [NSString stringWithFormat:@"减%@元", [_coupon.parValue convertToSimpleRealMoney]];
}

@end
