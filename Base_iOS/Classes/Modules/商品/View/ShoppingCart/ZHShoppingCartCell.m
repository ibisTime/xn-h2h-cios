//
//  ZHShoppingCartCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingCartCell.h"
#import "ZHStepView.h"
#import "ZHCartManager.h"
#import "TLCurrencyHelper.h"

NSString *const kSelectedAllCartGoodsNotification = @"kSelectedAllCartGoodsNotification";
 NSString *const kSelectedCartGoodsCountChangeNotification = @"kSelectedCartGoodsCountChangeNotification";

@interface ZHShoppingCartCell()

@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) UIImageView *coverImageV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *specLabel;   //规格

@property (nonatomic,strong) ZHStepView  *stepView;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation ZHShoppingCartCell


//监听 stepView 的count的变化,然后改变属于的模型
//1.先判断该商品是否为选中状态
- (void)deleteSelf {

    if (self.deleteFromCart) {
        self.deleteFromCart(self.item);
    }

}

//全选的事件处理
- (void)selectedAll:(NSNotification *)noti {

    BOOL isSelectedAll =  [noti.userInfo[@"isAll"] boolValue];
    NSString *imgName = nil;
    if (isSelectedAll) {
        
        imgName = @"selected";
        _item.isSelected = YES;
    } else {
        _item.isSelected = NO;
        imgName = @"unselected";


    }
   [self.selectedBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];

}



//选中通知
//tableview didselected 中发送通知
- (void)selectedChange:(NSNotification *)noti {

    if ([noti.userInfo[@"sender"] isEqual:self]) {//选中的为自己
        
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
       self.item.isSelected = YES;
        
    } else { //选中的是别人
    
         [self.selectedBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        self.item.isSelected = NO;

    }
    
//    _item.isSelected = !_item.isSelected;
    
    //告诉外界变化
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedCartGoodsCountChangeNotification object:nil userInfo:@{
                                                                                                                               @"sender": self
                                                                                                                               }];
}


- (void)setItem:(ZHCartGoodsModel *)item {
    
    _item = item;
    [self.coverImageV sd_setImageWithURL:[NSURL URLWithString:[_item.product.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
    self.nameLbl.text = _item.product.name;
//    self.priceLbl.text = [TLCurrencyHelper totalPriceWithQBB:_item.qbb GWB:_item.gwb RMB:_item.rmb];
    
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [[_item.productSpecs.price1 stringValue] convertToRealMoney]];
                                     
                                     
//                                     totalPriceAttr2WithQBB:_item.qbb GWB:_item.gwb RMB:_item.rmb bouns:CGRectMake(0, -2, 15, 15)];
    
    CartProductspecs *spec = _item.productSpecs;
    
    self.specLabel.text = spec.name;
    
    self.stepView.count = _item.quantity;
    //最大数量
    self.stepView.maxCount = spec.quantity;
    
    if (item.isSelected) {
        
       [self.selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        
    } else {
        
       [self.selectedBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    
    }
    
}


+ (CGFloat)rowHeight {
    
    return 140;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //全选的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAll:) name:kSelectedAllCartGoodsNotification object:nil];
        
        //去掉全选添加的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedChange:) name:@"innerSelectedChange" object:nil];
        
        
        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftMargin, 0, 20, 20) ];
        [self addSubview:self.selectedBtn];
        [self.selectedBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        self.selectedBtn.userInteractionEnabled = NO;
//        [self.selectedBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        self.selectedBtn.centerY = [[self class] rowHeight]/2.0;
        //
        self.coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectedBtn.xx + 11, kLeftMargin, 80, 80)];
        self.coverImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageV.backgroundColor = [UIColor whiteColor];
        self.coverImageV.clipsToBounds = YES;
        [self addSubview:self.coverImageV];
        
        //
        CGFloat nameH = [FONT(13) lineHeight];
        self.nameLbl = [UILabel labelWithFrame:CGRectMake(self.coverImageV.xx + 11, self.coverImageV.y + 5, kScreenWidth - self.coverImageV.xx - 26, nameH)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(13)
                                     textColor:[UIColor zh_textColor]];
        [self addSubview:self.nameLbl];
        
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.nameLbl.yy + 10, self.nameLbl.width, [FONT(15) lineHeight]) textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(15)
                                      textColor:[UIColor zh_themeColor]];
        [self addSubview:self.priceLbl];
        self.priceLbl.numberOfLines = 0;
        
        //规格
        self.specLabel = [UILabel labelWithFrame:CGRectMake(self.nameLbl.x, self.priceLbl.yy + 10, self.nameLbl.width, [FONT(12) lineHeight]) textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(12)
                                      textColor:[UIColor zh_textColor2]];
        [self addSubview:self.specLabel];
        
        //
        self.stepView = [[ZHStepView alloc] initWithFrame:CGRectMake(self.priceLbl.x,self.coverImageV.yy + 10, 145, 25) type:ZHStepViewTypeSimple];
        [self addSubview:self.stepView];
        
        __weak typeof(self) weakself = self;
        self.stepView.countChange = ^(NSUInteger count){
        
            NSInteger dValue = weakself.item.quantity - count;
            weakself.item.quantity = count;
            
            //配合购物车改变数量--带来价格变动
            if (weakself.isSelected) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedCartGoodsCountChangeNotification object:nil];
            }

            [weakself.activity startAnimating];
            TLNetworking *http = [TLNetworking new];
            http.code = @"808042";
            http.parameters[@"code"] = weakself.item.code;
            http.parameters[@"quantity"] = [NSString stringWithFormat:@"%ld",count];
            http.parameters[@"token"] = [TLUser user].token;
            [http postWithSuccess:^(id responseObject) {
                
                [ZHCartManager manager].count = [ZHCartManager manager].count - dValue;
                [weakself.activity stopAnimating];

            } failure:^(NSError *error) {
                [weakself.activity stopAnimating];
                [TLAlert alertWithInfo:@"编辑购物车失败"];
            }];

        
        };
        
        //
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 30, 15, 15, 15)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.centerY = self.stepView.centerY;
        [self addSubview:self.deleteBtn];
        
        
//        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.nameLbl.mas_left);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
//            make.bottom.lessThanOrEqualTo(self.coverImageV.mas_bottom);
//        }];
        
        //
        self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.coverImageV.x, 110, 20, 20)];
        self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        self.activity.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.activity];
//        self.activity.hidesWhenStopped = YES;
        [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(10);
            
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        //
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [[self class] rowHeight] - kLineHeight, kScreenWidth, kLineHeight)];
        line.backgroundColor = [UIColor zh_lineColor];
        [self addSubview:line];
        
    }
    return self;
    
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
