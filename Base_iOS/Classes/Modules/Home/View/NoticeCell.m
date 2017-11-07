//
//  NoticeCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeCell.h"

@interface NoticeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation NoticeCell

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
        
        [self iniSubviews];
    }
    
    return self;
}

-(void)iniSubviews {
    
    self.backgroundColor = kClearColor;
    
    CGFloat x = 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, kScreenWidth - 2*x, 125)];
    
    bgView.backgroundColor = kWhiteColor;
    
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    
    [self.contentView addSubview:bgView];
    
    self.bgView = bgView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 2*x, 45)];
    
    topView.backgroundColor = kAppCustomMainColor;
    [bgView addSubview:topView];
    //标题
    self.titleLabel = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:15.0];
    
    self.titleLabel.backgroundColor = kClearColor;
    
    [topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(x);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-x);
        make.height.mas_equalTo(20);
        
    }];
    
    self.contentLabel = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:15.0];
    
    self.contentLabel.frame = CGRectMake(x, topView.yy + x, self.bgView.width - 2*x, 15.0);
    
//    self.contentLabel.numberOfLines = 0;
    
    [bgView addSubview:self.contentLabel];

    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentLabel.yy + 15, kScreenWidth - 2*x, 35)];
    
    [bgView addSubview:self.bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.width, kLineHeight)];
    
    lineView.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:lineView];
    
    self.timeLabel = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:13.0];
    
    self.timeLabel.frame = CGRectMake(x, 0, self.bottomView.width - 2*x, 15.0);
    
    self.timeLabel.centerY = self.bottomView.height/2.0;
    
    [self.bottomView addSubview:self.timeLabel];
    
}

- (void)setNotice:(NoticeModel *)notice {

    _notice = notice;
    
    self.titleLabel.text = _notice.smsTitle;
    
    self.contentLabel.text = _notice.smsContent;
    
//    self.contentLabel.height = _notice.contentHeight;
//    
//    _notice.cellHeight = 45 + 15 + _notice.contentHeight + 15 + 35;
//    
//    self.bgView.height = _notice.cellHeight;
//    时间
    NSString *date = [_notice.pushedDatetime convertToDetailDate];
    
    NSAttributedString *timeAttr = [NSAttributedString getAttributedStringWithImgStr:@"时间" index:0 string:[NSString stringWithFormat:@"  %@", date] labelHeight:self.timeLabel.height];
    
    self.timeLabel.attributedText = timeAttr;
    
//    self.bottomView.y = self.contentLabel.yy + 15;
}

@end
