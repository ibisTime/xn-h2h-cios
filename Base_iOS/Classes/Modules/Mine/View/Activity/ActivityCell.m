//
//  ActivityCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ActivityCell.h"

@interface ActivityCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *dateBtn;

@property (nonatomic, strong) UIButton *detailBtn;

@end

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.contentView.backgroundColor = kPaleGreyColor;
    
    
    CGFloat x = 15;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    self.imgView = [[UIImageView alloc] init];
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    
    [bgView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(x);
        make.right.mas_equalTo(-x);
        make.height.mas_equalTo(180);
        make.top.mas_equalTo(10);
        
    }];
    
    self.dateBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    
    [self.dateBtn setImage:kImage(@"时间") forState:UIControlStateNormal];
    [bgView addSubview:self.dateBtn];
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(x);
        make.top.mas_equalTo(_imgView.mas_bottom).mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
        
    }];
    
    self.detailBtn = [UIButton buttonWithTitle:@"查看详情" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    [self.detailBtn setImage:kImage(@"更多") forState:UIControlStateNormal];
    
//    [self.detailBtn addTarget:self action:@selector(lookDetail:) forControlEvents:UIControlEventTouchUpInside];
    self.detailBtn.userInteractionEnabled = NO;
    
    [bgView addSubview:self.detailBtn];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-x);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_equalTo(0);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.detailBtn setTitleLeft];

}

#pragma mark Setting
- (void)setActivity:(ActivityModel *)activity {
    
    _activity = activity;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[_activity.advPic convertImageUrl]] placeholderImage:kImage(@"")];
    
    [self.dateBtn setTitle:[_activity.endDatetime convertDate] forState:UIControlStateNormal];
    
    [self.dateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.dateBtn setTitleRight];
}

#pragma mark - Events

//- (void)lookDetail:(UIButton *)sender {
//
//    NSInteger index = (sender.tag - 6000)/10;
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectActionWithType:index:)]) {
//
//        [self.delegate didSelectActionWithType:ActivityEventsTypeDetail index:index];
//    }
//}
@end
