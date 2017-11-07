//
//  MineHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView()

@property (nonatomic, strong) NSMutableArray <UIButton *>*btns;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.btns = [[NSMutableArray alloc] init];
        //
        [self initSubvies];
        //关注和粉丝
        [self initFoucsAndFans];
        //余额和积分
        [self initBalanceAndIntegral];
    }
    return self;
}

#pragma mark - Init

- (void)initSubvies {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    bgIV.image =kImage(@"我的-背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    
    //title
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, 20, kScreenWidth, 44) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(18) textColor:kWhiteColor];
    
    titleLbl.text = @"我的";
    
    [self addSubview:titleLbl];
    
    //设置
    UIButton *settingBtn = [UIButton buttonWithImageName:@"设置"];
    
    settingBtn.frame = CGRectMake(kScreenWidth - 44 - 8, 20, 44, 44);
    
    [settingBtn addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:settingBtn];
    
    CGFloat imgWidth = 68;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.frame = CGRectMake(15, 11 + kNavigationBarHeight, imgWidth, imgWidth);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [self addSubview:self.userPhoto];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    
    [self.userPhoto addGestureRecognizer:tapGR];
    
    //昵称
    self.nameLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:17.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.userPhoto.mas_top).offset(10);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
        
    }];
    
    //箭头
//    UIImageView *arrowImageView= [[UIImageView alloc] init];
//    [self addSubview:arrowImageView];
//    arrowImageView.image = [UIImage imageNamed:@"更多-白色"];
//    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.width.mas_equalTo(7);
//        make.height.mas_equalTo(12);
//        make.centerY.equalTo(self.userPhoto.mas_centerY).offset(0);
//
//    }];
}

- (void)initFoucsAndFans {
    
    //关注和粉丝

    NSArray *typeNames = @[@"关注",@"粉丝"];
    
    __block UIButton *lastBtn;
    [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14.0];
        
        [btn setTitle:[NSString stringWithFormat:@"%@ --", typeNames[idx]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(goFoucsAndFans:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = idx + 1000;
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
            
            if (idx == 0) {
                
                make.left.equalTo(self.nameLbl.mas_left);
                
            } else {
                
                make.left.equalTo(lastBtn.mas_right).offset(32);
            }
            
        }];
        
        lastBtn = btn;
    
        [self.btns addObject:btn];
        
    }];
    
    UIButton *foucsBtn = (UIButton *)[self viewWithTag:1000];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kWhiteColor;
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(foucsBtn.mas_right).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(2);
        make.centerY.mas_equalTo(foucsBtn.mas_centerY).mas_equalTo(0);
    }];
}

- (void)initBalanceAndIntegral {
    
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 110 + kNavigationBarHeight, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lineColor];
    [self addSubview:line];
    
    //余额和积分
    CGFloat y = line.yy;
    CGFloat w = kScreenWidth/2.0;
    CGFloat h = 50;
    NSArray *typeNames = @[@"余额:",@"积分:"];
    
    __block UIButton *lastBtn;
    [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat x = idx*w;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        
        [btn addTarget:self action:@selector(goFlowDetal:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx + 100;
        
        btn.titleLabel.font = Font(15.0);
        btn.titleLabel.width = w;
        
        [btn setTitle:[NSString stringWithFormat:@"%@ --", typeNames[idx]] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        
        [self addSubview:btn];

        [self.btns addObject:btn];
        
        lastBtn = btn;
        
    }];
    
    self.height = lastBtn.yy;
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kLineColor;
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - Events

- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeSelectPhoto idx:0];
    }
    
}

- (void)clickSetting:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeSetting idx:0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeDefault idx:0];
    }
    
}

- (void)goFlowDetal:(UIButton *)btn {
    
    NSInteger index = btn.tag - 100;
    
    MineHeaderSeletedType type = index == 0 ? MineHeaderSeletedTypeAccount: MineHeaderSeletedTypeIntregalFlow;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:type idx:btn.tag - 100];
        
    }
    
}

- (void)goFoucsAndFans:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeFoucsAndFans idx:index];
        
    }
}

#pragma mark - Setting
- (void)setFoucsNum:(NSString *)foucsNum {
    
    _foucsNum = foucsNum;
    
    [self.btns[0] setTitle:[NSString stringWithFormat:@"关注 %@", _foucsNum] forState:UIControlStateNormal];
    
}

- (void)setFansNum:(NSString *)fansNum {
    
    _fansNum = fansNum;
    
    [self.btns[1] setTitle:[NSString stringWithFormat:@"粉丝 %@", _fansNum] forState:UIControlStateNormal];
}

- (void)setRmbNum:(NSString *)rmbNum {
    
    _rmbNum = rmbNum;
    
    NSString *amountStr = [NSString stringWithFormat:@"余额: %@", _rmbNum];
    
    [self.btns[2] setTitle:amountStr forState:UIControlStateNormal];

    [self.btns[2].titleLabel labelWithString:amountStr title:_rmbNum font:Font(17.0) color:kAppCustomMainColor];
    
}

- (void)setJfNum:(NSString *)jfNum {
    
    _jfNum = jfNum;
    
    NSString *amountStr = [NSString stringWithFormat:@"积分: %@", _jfNum];

    [self.btns[3] setTitle:amountStr forState:UIControlStateNormal];

    [self.btns[3].titleLabel labelWithString:amountStr title:_jfNum font:Font(17.0) color:kAppCustomMainColor];

}

- (void)reset {
    
//    [self.btns enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.text = @"--";
//    }];
    
}

@end
