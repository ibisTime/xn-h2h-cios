//
//  GoodDetailCommentCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodDetailCommentCell.h"
#import "LayoutHelper.h"
#import "LinkLabel.h"
#import "UserPhotoView.h"

@interface GoodDetailCommentCell ()

@property (nonatomic, strong) UserPhotoView *photoImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) LinkLabel *commentContentLbl;

@end

@implementation GoodDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        CGFloat photoW = 40;
        
        self.photoImageView = [[UserPhotoView alloc] initWithFrame:CGRectMake(15, 15, photoW, photoW)];
        [self.contentView addSubview:self.photoImageView];
        self.photoImageView.layer.cornerRadius = 20;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:Font(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.nameLbl];
        
        //来自板块
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_top).offset(6);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
            //            make.right.lessThanOrEqualTo(self.contentView.mas_left).offset(10);
            
        }];
        
        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:Font(12)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.top.equalTo(self.photoImageView.mas_centerY).offset(5);
            make.right.lessThanOrEqualTo(self.contentView.mas_right);
            
        }];
        
        self.commentContentLbl = [[LinkLabel alloc] initWithFrame:CGRectZero];
        self.commentContentLbl.font = Font(15.0);
        self.commentContentLbl.textColor = [UIColor textColor];
        self.commentContentLbl.numberOfLines = 0;
        [self.contentView addSubview:self.commentContentLbl];
        [self.commentContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.height.lessThanOrEqualTo(@(MAXFLOAT));
            make.width.equalTo(@(kScreenWidth - 3*15 - photoW));
            make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
        }];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(kLineHeight);
            make.top.equalTo(self.mas_top);
        }];
        
    }
    
    return self;
    
}

- (void)setCommentLayoutItem:(CommentLayoutItem *)commentLayoutItem {
    
    _commentLayoutItem = commentLayoutItem;
    
    CommentModel *comment = _commentLayoutItem.commentModel;
    
    //
    self.photoImageView.userId = comment.commenter;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[comment.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    self.nameLbl.text = comment.nickname;
    
    //
    self.timeLbl.text = [comment.commentDatetime convertToTimelineDate];
    
    self.commentContentLbl.text = comment.content;
    
    [self.contentView layoutIfNeeded];
    
    _commentLayoutItem.cellHeight = self.commentContentLbl.yy + 15;
    
    //
//    self.commentContentLbl.frame = _commentLayoutItem.commentFrame;
//    self.commentContentLbl.attributedText = _commentLayoutItem.commentAttrStr;
    
}

@end
