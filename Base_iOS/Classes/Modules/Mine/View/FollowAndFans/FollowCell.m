//
//  FollowCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FollowCell.h"

@interface FollowCell ()

@property (nonatomic, strong) UIImageView *userPhoto;

@property (nonatomic, strong) UILabel *nameLbl;

@end

@implementation FollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat imgWidth = 50;

        self.userPhoto = [[UIImageView alloc] init];
        
        self.userPhoto.layer.cornerRadius = imgWidth/2.0;
        self.userPhoto.layer.masksToBounds = YES;
        self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        
        self.userPhoto.userInteractionEnabled = YES;
        
        [self addSubview:self.userPhoto];
        [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@(imgWidth));
            
        }];
        
        //昵称
        self.nameLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:17.0];
        
        [self addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.userPhoto.mas_centerY);
            make.left.equalTo(self.userPhoto.mas_right).offset(10);
            
        }];
    }
    
    return self;
}

- (void)setFollow:(FollowAndFansModel *)follow {
    
    _follow = follow;
    
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[_follow.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = _follow.nickname;
    
}
@end
