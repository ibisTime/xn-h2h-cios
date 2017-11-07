//
//  BillTableViewCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BillTableViewCell.h"

@interface BillTableViewCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

@property (nonatomic, strong) UILabel *dayLbl;

@property (nonatomic,strong) UILabel *timeLbl;

@end

@implementation BillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat left = 15;
        CGFloat timeW = 100;

        //
        self.dayLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:[UIFont secondFont]
                                    textColor:[UIColor zh_textColor]];
        [self addSubview:self.dayLbl];
        
        [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY).offset(-10);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(12.0)
                                     textColor:[UIColor zh_textColor2]];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY).offset(10);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        
        self.iconIV = [[UIImageView alloc] init];
        
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(36);
            make.left.mas_equalTo(self.timeLbl.mas_right).mas_equalTo(15);
            
        }];
        
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectMake(left, 15, kScreenWidth - left - timeW - 15, 20) textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:[UIFont firstFont]
                                      textColor:[UIColor zh_themeColor]];
        self.moneyLbl.height = [[UIFont firstFont] lineHeight];
        [self addSubview:self.moneyLbl];
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(-12.5);
            
        }];
        
        
        //
        self.detailLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:FONT(14)
                                       textColor:[UIColor zh_textColor2]];
        self.detailLbl.numberOfLines = 0;
        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).mas_equalTo(2.5);
            make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_lessThanOrEqualTo(60);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(0.5));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
    
}

- (void)setBillModel:(BillModel *)billModel {
    
    _billModel = billModel;
    
    //橙券
    
    long long money = [_billModel.transAmount longLongValue];

    NSString *moneyStr = @"";
    
    if (money > 0) {
        moneyStr = [NSString stringWithFormat:@"+%@", [_billModel.transAmount convertToRealMoney ]];
        
        self.iconIV.image = [UIImage imageNamed:@"收"];
        
        self.moneyLbl.textColor = kAppCustomMainColor;
        
    } else if (money <= 0) {
        
        moneyStr = [NSString stringWithFormat:@"%@", [_billModel.transAmount convertToRealMoney ]];
        self.iconIV.image = [UIImage imageNamed:@"支"];

        self.moneyLbl.textColor = [UIColor colorWithHexString:@"#3DA3FF"];

    }
    
    self.dayLbl.text = [_billModel.createDatetime convertDateWithFormat:@"dd日"];
    self.timeLbl.text = [_billModel.createDatetime convertDateWithFormat:@"HH:mm"];

    self.moneyLbl.text = moneyStr;
    
    self.detailLbl.text = _billModel.bizNote;
    
}

@end
