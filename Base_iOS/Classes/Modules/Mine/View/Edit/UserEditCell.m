//
//  UserEditCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UserEditCell.h"

@implementation UserEditCell

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
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //标题
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
                                           font:FONT(15)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        
        //内容
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor]
                                             font:FONT(15)
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.contentLbl];
        
        self.userPhoto = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userPhoto];
        self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        self.userPhoto.layer.cornerRadius = 30.0;
        self.userPhoto.clipsToBounds = YES;
        
        
        
        //
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentLbl.mas_left);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.greaterThanOrEqualTo(self.titleLbl.mas_right);
        }];
        
        [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.equalTo(self.contentView.mas_right);
            make.width.mas_equalTo(60);
            
            
        }];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(@(kLineHeight));
            make.bottom.mas_equalTo(0);
            
        }];
        
        _lineView = line;
        
    }
    return self;
    
}

@end
