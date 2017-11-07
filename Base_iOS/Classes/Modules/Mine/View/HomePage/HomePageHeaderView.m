//
//  HomePageHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomePageHeaderView.h"

@interface HomePageHeaderView ()

//上线时间
@property (nonatomic, strong) UILabel *timeLineLbl;
//加入时间
@property (nonatomic, strong) UILabel *addTimeLbl;
//累计发布
@property (nonatomic, strong) UIView *contentView;
//私聊
@property (nonatomic, strong) UIButton *chatBtn;

@end

@implementation HomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        [self initBackgroundView];
        //内容
        [self initContentView];
        
    }
    return self;
}

#pragma mark - Init
- (void)initBackgroundView {
    
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"主页背景")];
    
    [self addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@150);
        
    }];
    self.bgIV = iconIV;
    
    //灰色
    UIView *greyView = [[UIView alloc] init];
    
    greyView.backgroundColor = kBackgroundColor;
    
    greyView.tag = 1250;
    
    [self addSubview:greyView];
    
}

- (void)initContentView {
    
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@70);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(210));
        
    }];
    
    self.contentView = whiteView;
    
    //头像
    CGFloat imgWidth = 68;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [whiteView addSubview:self.userPhoto];
    [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.top.equalTo(@15);
        make.width.height.equalTo(@(imgWidth));
        
    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:24.0];
    
    [whiteView addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhoto.mas_top).offset(10);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
        
    }];
    //上线时间
    self.timeLineLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:14.0];
    
    [whiteView addSubview:self.timeLineLbl];
    [self.timeLineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.userPhoto.mas_bottom).offset(18);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    
    //加入时间
    self.addTimeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:14.0];
    
    self.addTimeLbl.numberOfLines = 0;
    
    [whiteView addSubview:self.addTimeLbl];
    [self.addTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userPhoto.mas_left);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
    
    //编辑/关注
    self.followBtn = [UIButton buttonWithTitle:@"+ 关注" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:2.5];
    
    [self.followBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.followBtn.layer.borderWidth = 1;
    self.followBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    [whiteView addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.top.equalTo(self.addTimeLbl.mas_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@27);
        
    }];
    
    //私聊
    self.chatBtn = [UIButton buttonWithTitle:@"私聊" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:2.5];
    
    [self.chatBtn addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
    
    self.chatBtn.layer.borderWidth = 1;
    self.chatBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    
    self.chatBtn.hidden = YES;
    
    [whiteView addSubview:self.chatBtn];
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.followBtn.mas_left).offset(-10);
        make.top.equalTo(self.followBtn.mas_top);
        make.width.equalTo(@80);
        make.height.equalTo(@27);
        
    }];
    
}

- (void)initTotalView {
    
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@50);
        
    }];
    
    NSString *text = [NSString stringWithFormat:@"累计发布宝贝%ld个, 在架%ld个", self.publishNum, self.onNum];
    UILabel *textLbl = [UILabel labelWithText:text textColor:kTextColor textFont:15.0];
    
    [whiteView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(whiteView.mas_centerX);
        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    //左引号
    UIImageView *leftIV = [[UIImageView alloc] initWithImage:kImage(@"左引号")];
    
    [whiteView addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(textLbl.mas_left).offset(-6);
        make.top.equalTo(textLbl.mas_top);
        
    }];
    //右引号
    UIImageView *rightIV = [[UIImageView alloc] initWithImage:kImage(@"右引号")];
    
    [whiteView addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right).offset(6);
        make.top.equalTo(textLbl.mas_bottom).offset(-3);
        
    }];
    
    
}

#pragma mark - Setting

- (void)setUser:(TLUser *)user {
    
    _user = user;
    
    if ([user.userId isEqualToString:[TLUser user].userId]) {
        
        self.chatBtn.hidden = YES;
        
        [self.followBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
    } else {
        
        self.chatBtn.hidden = NO;

    }
    
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:[_user.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = _user.nickname;
    
    NSString *date = [NSString stringWithTimeStr:_user.loginDatetime format:@"MMM dd, yyyy hh:mm:ss aa"];
    
    self.timeLineLbl.text = [NSString stringWithFormat:@"%@来过", date];
    
    NSString *addTime = [NSString stringWithTimeStr:_user.createDatetime format:@"MMM dd, yyyy hh:mm:ss aa"];
    
    [self.addTimeLbl labelWithTextString:[NSString stringWithFormat:@"%@加入我淘网\n个人简介: %@", addTime, [TLUser user].introduce] lineSpace:5];
    
//    self.addTimeLbl.text = ;
    
    [self layoutSubviews];

    NSLog(@"height = %lf", self.addTimeLbl.yy + 20);

    [self addConstraints];
    
    
}

- (void)addConstraints {
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@70);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(self.followBtn.yy + 20 + 70));

    }];
    
    UIView *greyView = [self viewWithTag:1250];
    
    [greyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.bgIV.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];

}

- (void)setOnNum:(NSInteger)onNum {
    
    _onNum = onNum;
    
    [self initTotalView];
}

- (void)setIsFollow:(BOOL)isFollow {
    
    _isFollow = isFollow;
    
    self.followBtn.selected = _isFollow;

    [self.followBtn setTitle:@"取消关注" forState:UIControlStateSelected];
    
}

#pragma mark - Events
- (void)clickButton:(UIButton *)sender {
    
    if (_headerBlock) {
        
        HomePageType type = [_user.userId isEqualToString:[TLUser user].userId] ? HomePageTypeEdit: (sender.selected == YES ? HomePageTypeCancelFollow: HomePageTypeFollow);
        
        _headerBlock(type);
    }

}

- (void)clickChat:(UIButton *)sender {
    
    if (_headerBlock) {
        
        _headerBlock(HomePageTypeChat);
    }
}

@end
