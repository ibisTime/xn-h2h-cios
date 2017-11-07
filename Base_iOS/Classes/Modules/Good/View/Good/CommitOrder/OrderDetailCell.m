//
//  OrderDetailCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/20.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderDetailCell.h"

@interface OrderDetailCell ()

@property (nonatomic,strong) UIImageView *coverImageV;

@property (nonatomic,strong) UILabel *nameLbl;
//商品描述
@property (nonatomic,strong) UILabel *sloginLbl;
//数目
@property (nonatomic,strong) UILabel *numLbl;

@end

@implementation OrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.coverImageV = [[UIImageView alloc] init];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.clipsToBounds = YES;
        self.coverImageV.layer.masksToBounds  = YES;
        self.coverImageV.layer.cornerRadius = 2;
        self.coverImageV.layer.borderWidth = 0.5;
        self.coverImageV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverImageV];
        [self.coverImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(80);
            make.bottom.mas_equalTo(-10);
            
        }];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:kClearColor font:Font(15.0) textColor:kTextColor];
        
        self.nameLbl.numberOfLines = 0;
        
        [self addSubview:self.nameLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.coverImageV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_lessThanOrEqualTo(MAXFLOAT);
            
        }];
        
        //商品描述
        self.sloginLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(13.0)
                                      textColor:kTextColor2];
        
        self.sloginLbl.numberOfLines = 2;
        [self addSubview:self.sloginLbl];
        [self.sloginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.nameLbl.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(self.nameLbl.mas_left);
            make.height.mas_lessThanOrEqualTo(100);
            
        }];
        
        //数量
        self.numLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:kClearColor
                                         font:Font(13)
                                    textColor:kTextColor];
        
        [self addSubview:self.numLbl];
        [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_equalTo(kFontHeight(13.0));
            make.bottom.mas_equalTo(-15);
            
        }];
        
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

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    OrderDetailModel *product = _order.productOrderList[0];
    
    NSString *urlStr = [product.productPic componentsSeparatedByString:@"||"][0];
    
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    //
    self.nameLbl.text = product.productName;
    
    //
    self.sloginLbl.text = [NSString stringWithFormat:@"%@", product.productDescription];
    
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[product.quantity stringValue]];
    
}

+ (CGFloat)rowHeight {
    
    return 96;
}

@end
