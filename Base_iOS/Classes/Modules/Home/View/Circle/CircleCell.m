//
//  CircleCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CircleCell.h"
#import "PYPhotosView.h"
#import <PYPhotoView.h>
#import "PhotosView.h"

#import <UIView+PYExtension.h>

@interface CircleCell ()

//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//地点
@property (nonatomic, strong) UILabel *addressLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//来自哪里
@property (nonatomic, strong) UILabel *fromLbl;
//图片
@property (nonatomic, strong) PYPhotosView *photosView;
//商品名称
@property (nonatomic, strong) UILabel *goodNameLbl;
//商品价格
@property (nonatomic, strong) UILabel *priceLbl;
//收藏数
@property (nonatomic, strong) UILabel *collectNumLbl;
//评论数
@property (nonatomic, strong) UILabel *commentNumLbl;

@end

@implementation CircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat leftMargin = 15;
        
        CGFloat headIconH = 37;
        //头像
        self.photoImageView = [[UserPhotoView alloc] init];
        
        self.photoImageView.layer.cornerRadius = headIconH/2.0;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.photoImageView.backgroundColor = kBlackColor;
        
        [self addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(leftMargin));
            make.top.equalTo(@(leftMargin));
            make.width.height.equalTo(@(headIconH));
            
        }];
        //昵称
        self.nickNameLbl = [UILabel labelWithText:@"" textColor:[UIColor textColor] textFont:14.0];
        
        [self addSubview:self.nickNameLbl];
        
        [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photoImageView.mas_top).offset(2);
            make.left.equalTo(self.photoImageView.mas_right).offset(12);
            
        }];
        //地址
        self.addressLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:12.0];
        
        [self addSubview:self.addressLbl];
        [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.nickNameLbl.mas_bottom).offset(3);
            make.left.equalTo(self.nickNameLbl.mas_left);
            
        }];
        //
        UIView *vLine = [[UIView alloc] init];
        
        vLine.backgroundColor = kTextColor2;
        
        [self addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.addressLbl.mas_right).offset(6);
            make.centerY.equalTo(self.addressLbl.mas_centerY);
            make.width.equalTo(@(1));
            make.height.equalTo(@(12));
            
        }];
        //时间
        self.timeLbl = [UILabel labelWithText:@"" textColor:kTextColor2 textFont:12.0];
        
        [self addSubview:self.timeLbl];
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(vLine.mas_right).offset(6);
            
            make.top.equalTo(self.addressLbl.mas_top);
        }];
        
        //来自哪里
        self.fromLbl = [UILabel labelWithText:@"" textColor:kAppCustomMainColor textFont:12.0];
        
        [self addSubview:self.fromLbl];
        [self.fromLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.photoImageView.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
            
        }];

        //
        CGFloat photoH = (kScreenWidth - 15*2 - 2*3)/3.0;

        self.photosView = [[PYPhotosView alloc] init];
        
        self.photosView.frame = CGRectMake(15, 63, kScreenWidth - 15, photoH);
        
        self.photosView.layoutType = PYPhotosViewLayoutTypeLine;
        
        self.photosView.photoMargin = 1;
        self.photosView.photoHeight = photoH;
        self.photosView.photoWidth = photoH;
        [self addSubview:self.photosView];

//        商品名称
        self.goodNameLbl = [UILabel labelWithText:@"" textColor:kTextColor textFont:15.0];

        self.goodNameLbl.numberOfLines = 0;

        [self addSubview:self.goodNameLbl];
        [self.goodNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.mas_left).offset(leftMargin);
            make.top.equalTo(self.photoImageView.mas_bottom).offset(10 + photoH + 10);
            make.right.equalTo(self.mas_right).offset(-leftMargin);
        }];

        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:Font(24)
                                        textColor:kThemeColor];
        [self addSubview:self.priceLbl];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.goodNameLbl.mas_bottom).offset(15);
            make.left.mas_equalTo(self.goodNameLbl.mas_left).offset(-2);

        }];
        
        //评论数
        self.commentNumLbl = [UILabel labelWith:@"" font:12.0 textColor:kTextColor];
        
        [self addSubview:self.commentNumLbl];
        [self.commentNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            
        }];
        
        UIImageView *commentIV = [[UIImageView alloc] initWithImage:kImage(@"留言框")];
        
        [self addSubview:commentIV];
        [commentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.commentNumLbl.mas_left).offset(-6);
            make.centerY.equalTo(self.commentNumLbl.mas_centerY);

        }];
        
        //收藏数
        self.collectNumLbl = [UILabel labelWith:@"" font:12.0 textColor:kTextColor];
        
        [self addSubview:self.collectNumLbl];
        [self.collectNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(commentIV.mas_left).offset(-20);
            make.centerY.equalTo(self.commentNumLbl.mas_centerY);

        }];
        
        UIImageView *zanIV = [[UIImageView alloc] initWithImage:kImage(@"想要-灰色")];
        
        [self addSubview:zanIV];
        [zanIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.collectNumLbl.mas_left).offset(-6);
            make.centerY.equalTo(self.commentNumLbl.mas_centerY);

        }];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@0.5);
        }];
        
        
    }
    return self;
}

- (void)setGoodModel:(GoodModel *)goodModel {
    
    _goodModel = goodModel;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_goodModel.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nickNameLbl.text = _goodModel.nickName;
    
    self.addressLbl.text = _goodModel.city;
    //转化
    NSString *date = [NSString stringWithTimeStr:_goodModel.loginLog format:@"MMM dd, yyyy hh:mm:ss aa"];
    
    self.timeLbl.text = [NSString stringWithFormat:@"%@来过", date];
    
    self.fromLbl.text = [NSString stringWithFormat:@"来自%@", _goodModel.typeName];
    
    //照片
    _photosView.thumbnailUrls = _goodModel.originalUrls;
    
    _photosView.originalUrls = _goodModel.originalUrls;
    
    self.photosView.photosMaxCol = 12;

    self.goodNameLbl.text = _goodModel.name;
    
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_goodModel.price convertToSimpleRealMoney]];
    
    self.commentNumLbl.text = [_goodModel.totalComment stringValue];
//
    self.collectNumLbl.text = [_goodModel.totalInteract stringValue];
    
    [self layoutSubviews];
    
    _goodModel.cellHeight = self.priceLbl.yy + 15;
    
}



@end
