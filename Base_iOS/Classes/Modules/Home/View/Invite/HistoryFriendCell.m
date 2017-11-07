//
//  HistoryFriendCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HistoryFriendCell.h"

@interface HistoryFriendCell ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;

@property (nonatomic,strong) UILabel *timeLbl;

@end

@implementation HistoryFriendCell

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
        
        CGFloat iconW = 45;
        
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, iconW, iconW)];
        self.coverImageV.layer.masksToBounds = YES;
        self.coverImageV.layer.cornerRadius = iconW/2.0;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.coverImageV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectMake( self.coverImageV.xx + 10, self.coverImageV.y, kScreenWidth - self.coverImageV.xx - 13, 10) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:kTextColor];
        [self addSubview:self.nameLbl];
        self.nameLbl.height = [[UIFont secondFont] lineHeight];
        
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, [FONT(11) lineHeight])
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:kTextColor2];
        [self addSubview:self.timeLbl];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

+ (CGFloat)rowHeight {
    
    return 75;
}

- (void)setInviteModel:(InviteModel *)inviteModel {
    
    _inviteModel = inviteModel;
    //
    NSString *urlStr = [_inviteModel.photo convertImageUrl];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:urlStr]
                        placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLbl.text = _inviteModel.mobile;
    self.timeLbl.text = [NSString stringWithFormat:@"加入时间: %@", [_inviteModel.createDatetime convertDate]];
    
}

@end
