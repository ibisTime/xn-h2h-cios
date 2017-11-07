//
//  PublishCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PublishCell.h"

@interface PublishCell()

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation PublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //右箭头
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多-灰色"]];
        
        rightArrow.contentMode = UIViewContentModeScaleAspectFit;
        
        rightArrow.frame = CGRectMake(kScreenWidth - 6 - 15, 20, 6, 10);
        
//        rightArrow.centerY = self.centerY;
        
        [self addSubview:rightArrow];
        
        self.rightArrow = rightArrow;
        
        self.rightLabel = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:15.0];
        
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(250);
            make.height.mas_equalTo(15.0);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            
        }];
        
        //
        self.titleLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:15.0];
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(kLineHeight));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        UISwitch *sw = [[UISwitch alloc] init];
        
        [self addSubview:sw];
        [sw mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_lessThanOrEqualTo(100);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            
        }];
        
        self.sw = sw;
        
    }
    return self;
    
}

- (void)setArrowHidden:(BOOL)arrowHidden {
    
    _arrowHidden = arrowHidden;
    
    _rightArrow.hidden = _arrowHidden;
    
    if (!_arrowHidden) {
        
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.rightArrow.mas_left).mas_equalTo(-10);
            
        }];
    }
    
}

- (void)setSwitchHidden:(BOOL)switchHidden {
    
    _switchHidden = switchHidden;
    
    _sw.hidden = switchHidden;

}

@end
