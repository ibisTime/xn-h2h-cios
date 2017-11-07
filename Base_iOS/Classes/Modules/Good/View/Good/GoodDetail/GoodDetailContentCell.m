//
//  GoodDetailContentCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodDetailContentCell.h"
#import "MLLinkLabel.h"
#import "PYPhotosView.h"
#import <PYPhotoView.h>
#import "PhotosView.h"

#import <UIView+PYExtension.h>
#import <PYProgressView.h>

#import "LinkLabel.h"

@interface GoodDetailContentCell ()
//文字
@property (nonatomic, strong) UILabel *contentLbl;
//展开/收起
@property (nonatomic, strong) UIButton *showBtn;
//图片
@property (nonatomic, strong) PhotosView *photosView;
//
@property (nonatomic, strong) UIView *bgView;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//性别
@property (nonatomic, strong) UILabel *genderLbl;

@property (nonatomic, strong) NSMutableArray <UILabel *>*lbls;
//右箭头
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation GoodDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat margin = 15;
        
        //内容
        self.contentLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:14.0];
        
        self.contentLbl.numberOfLines = 5;
        self.contentLbl.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.mas_equalTo(margin);
            make.height.mas_lessThanOrEqualTo(MAXFLOAT);
            make.width.mas_equalTo(kScreenWidth - 2*margin);
            
        }];
        
        self.showBtn = [UIButton buttonWithTitle:@"展开" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:13.0];
        
        [self.showBtn setImage:kImage(@"展开") forState:UIControlStateNormal];
        
        [self.showBtn setTitle:@"收起" forState:UIControlStateSelected];
        
        [self.showBtn setImage:kImage(@"收起") forState:UIControlStateSelected];
        
        [self.showBtn addTarget:self action:@selector(showTitleContent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.showBtn setEnlargeEdge:20];
        
        [self.contentView addSubview:self.showBtn];
        [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.contentLbl.mas_bottom).mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(50);
            
        }];
        
        [self.showBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_showBtn.imageView.width - 20, 0, 0)];
        [self.showBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_showBtn.titleLabel.intrinsicContentSize.width - 20)];
        
        //bgView
        self.bgView = [[UIView alloc] init];
        
        self.bgView.backgroundColor = kWhiteColor;
        
        self.photoImageView = [[UserPhotoView alloc] init];
        
        self.photoImageView.layer.cornerRadius = 25;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.photoImageView.backgroundColor = kBlackColor;
        
        [self.bgView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(15));
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@50);
            
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIcon:)];
        
        [self.bgView addGestureRecognizer:tapGR];
        
        //名称
        self.nameLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        
        [self.bgView addSubview:self.nameLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoImageView.mas_top).offset(5);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
            
        }];
        
        //关注和粉丝
        [self initFoucsAndFans];

        //箭头
        UIImageView *arrowImageView= [[UIImageView alloc] init];

        arrowImageView.image = [UIImage imageNamed:@"更多"];

        [self.bgView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.bgView.mas_right).offset(-15);
            make.width.equalTo(@7);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.bgView.mas_centerY).offset(0);

        }];
        
    }
    
    return self;
    
}

- (void)initPhotoView {
    
    GoodModel *good = _layoutItem.good;
    
    //添加图片
    PhotosView *photosView = [[PhotosView alloc] init];
    
    photosView.backgroundColor = kWhiteColor;
    
    photosView.pics = good.pics;
    
    [self.contentView addSubview:photosView];
    
    [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(photosView.photoH);
        make.width.mas_equalTo(kScreenWidth);
        
        if (!_showBtn.hidden) {
            
            make.top.mas_equalTo(self.showBtn.mas_bottom).mas_equalTo(0);
            
        } else {
            
            make.top.mas_equalTo(self.contentLbl.mas_bottom).mas_equalTo(10);
        }
        
    }];
    
    self.photosView = photosView;
}

- (void)initFoucsAndFans {
    
    //关注和粉丝
    NSArray *typeNames = @[@"关注",@"粉丝"];
    
    self.lbls = [NSMutableArray array];
    
    [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //
        UILabel *typeNameLbl = [UILabel labelWithText:typeNames[idx] textColor:kTextColor textFont:14.0];
        
        typeNameLbl.textAlignment = NSTextAlignmentCenter;
        typeNameLbl.backgroundColor = kClearColor;
        
        typeNameLbl.tag = 1000 + idx;
        
        [self.bgView addSubview:typeNameLbl];
        
        [typeNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.photoImageView.mas_bottom).offset(-5);
            if (idx == 0) {
                
                make.left.equalTo(self.nameLbl.mas_left);

            } else {
                
                UILabel *lbl1 = self.lbls[0];
                make.left.equalTo(lbl1.mas_right).offset(13);
            }
            
        }];
        
        //
        UILabel *numLbl = [UILabel labelWithText:@"--" textColor:kTextColor textFont:14.0];
        
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.backgroundColor = kClearColor;
        [self.bgView addSubview:numLbl];
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(typeNameLbl.mas_right).offset(6);
            make.top.equalTo(typeNameLbl.mas_top);
            
        }];
        
        [self.lbls addObject:numLbl];
        
    }];
    
    UILabel *lbl1 = self.lbls[0];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kTextColor2;
    
    [self.bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lbl1.mas_right).offset(6);
        make.height.equalTo(@15);
        make.width.equalTo(@1);
        make.centerY.equalTo(lbl1.mas_centerY).offset(0);
        
    }];
    
    UILabel *lbl2 = self.lbls[1];

    //性别
    self.genderLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:14.0];
    
    [self.bgView addSubview:self.genderLbl];
    [self.genderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lbl2.mas_right).offset(6);
        make.top.equalTo(lbl2.mas_top);
        
    }];
}

#pragma mark - Events

- (void)showTitleContent:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        _contentLbl.numberOfLines = 0;
        
        [_contentLbl labelWithTextString:_layoutItem.good.desc lineSpace:5];
    } else {
        
        _contentLbl.numberOfLines = 5;
        
        [_contentLbl labelWithTextString:_layoutItem.good.desc lineSpace:5];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectActionWithType:index:)]) {
        
        [self.delegate didSelectActionWithType:GoodDetailEventsTypeShowTitle index:0];
    }
}

- (void)clickHeadIcon:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = (tapGR.view.tag - 5000)/10;
    
    if ([self.delegate respondsToSelector:@selector(didSelectActionWithType:index:)]) {
        
        [self.delegate didSelectActionWithType:GoodDetailEventsTypeHeadIcon index:index];
    }
}

#pragma mark - Setting

- (void)setLayoutItem:(GoodDetailLayoutItem *)layoutItem {
    
    _layoutItem = layoutItem;
    
    GoodModel *good = _layoutItem.good;
    
    //_layoutItem.good.desc
    [_contentLbl labelWithTextString:good.desc lineSpace:5];
    
    //判断是否超出5行
    NSInteger lineCount = [_contentLbl getLinesArrayOfStringInLabel];
    
    _showBtn.hidden = lineCount > 5 ? NO: YES;
    
    [self initPhotoView];
    
    //灰色背景
    UIView *greyView = [[UIView alloc] init];
    
    greyView.backgroundColor = kBackgroundColor;
    
    [self.contentView addSubview:greyView];
    
    [greyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.photosView.mas_bottom).mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(100);
        
    }];
    
    [greyView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth - 2*15);
        make.height.mas_equalTo(90);
        
    }];
    
    [self.contentView layoutIfNeeded];
    
    _layoutItem.cellHeight = greyView.yy;
    
}

- (void)setUser:(TLUser *)user {
    
    _user = user;
    
    //用户资料
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[_user.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    _nameLbl.text = _user.nickname;
    
    UILabel *lbl1 = self.lbls[0];
    
    lbl1.text = [_user.totalFollowNum stringValue];
    
    UILabel *lbl2 = self.lbls[1];
    
    lbl2.text = [_user.totalFansNum stringValue];
    
    //性别
    _genderLbl.text = [_user.gender isEqualToString:@"0"] ? @"女": @"男";
}

@end
