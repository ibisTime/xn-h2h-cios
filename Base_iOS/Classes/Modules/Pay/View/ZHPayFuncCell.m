//
//  ZHPayFuncCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHPayFuncCell.h"

#define PAY_TYPE_CHANGE_NOTIFICATION @"PAY_TYPE_CHANGE_NOTIFICATION"

@implementation ZHPayFuncCell

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.funcTypeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25,25)];
        [self addSubview:self.funcTypeImageV];
        
        //
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
        
        //
        self.infoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:Font(13.0)
                                     textColor:[UIColor textColor]];
        [self addSubview:self.infoLbl];
        
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.height.equalTo(self);
            make.left.equalTo(self.funcTypeImageV.mas_right).offset(10);
            make.right.equalTo(self.selectedBtn.mas_left);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-0.3);
            make.height.mas_equalTo(0.5);
        }];
        
        
    }
    
    return self;
}

- (void)setPay:(ZHPayFuncModel *)pay {
    
    _pay = pay;
    
    self.funcTypeImageV.image = [UIImage imageNamed:_pay.payImgName];
    self.infoLbl.text = _pay.payName;
    
    if (_pay.isSelected) {
        
        self.selectedBtn.selected = YES;
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
