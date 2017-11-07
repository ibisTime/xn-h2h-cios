//
//  RechargeCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "RechargeCell.h"

@interface RechargeCell ()

@property (nonatomic, strong) UIImageView *payIV;

@property (nonatomic, strong) UILabel *payLabel;

@end

@implementation RechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initSubviews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(25);
    }];
    
    self.payIV = imageView;
    
    UILabel *label = [UILabel labelWithText:@"" textColor:kTextColor textFont:15.0];

    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_equalTo(17);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_lessThanOrEqualTo(30);
    }];
    
    self.payLabel = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:@"发布_未选中"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"发布_选中"] forState:UIControlStateSelected];
    
    btn.userInteractionEnabled = NO;
    
    btn.selected = YES;
    
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    self.payBtn = btn;
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kPaleGreyColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
}

- (void)setImgStr:(NSString *)imgStr {

    _imgStr = imgStr;
    
    self.payIV.image = [UIImage imageNamed:_imgStr];
}

- (void)setPayName:(NSString *)payName {

    _payName = payName;
    
    self.payLabel.text = _payName;
}

@end
