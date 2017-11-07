//
//  FilterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterView.h"
#import "FilterManager.h"

@interface FilterView ()<UITextFieldDelegate>
//顶部
@property (nonatomic, strong) UIView *topView;
//包邮
@property (nonatomic, strong) UIButton *freightBtn;
//全新
@property (nonatomic, strong) UIButton *freshBtn;
//重置
@property (nonatomic, strong) UIButton *resetBtn;
//确认
@property (nonatomic, strong) UIButton *confirmBtn;
//最低价
@property (nonatomic, strong) UITextField *minPriceTF;
//最高价
@property (nonatomic, strong) UITextField *maxPriceTF;
//
@property (nonatomic, strong) NSArray *priceArr;
//
@property (nonatomic, strong) NSMutableArray <UIButton *>*btnArr;
//包邮
@property (nonatomic, assign) BOOL isFreight;
//全新
@property (nonatomic, assign) BOOL isNew;
//最高价
@property (nonatomic, copy) NSString *maxPrice;
//最低价
@property (nonatomic, copy) NSString *minPrice;

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //顶部
        [self initTopView];
        //中间
        [self initCenterView];
        //底部
        [self initBottomView];
    }
    return self;
}

- (void)initTopView {
    
    self.isFreight = NO;
    
    self.isNew = NO;
    
    CGFloat leftMargin = 10;
    
    //
    UILabel *textLbl = [UILabel labelWithText:@"快捷筛选（可多选）" textColor:kTextColor textFont:13.0];
    
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(47);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_equalTo(kFontHeight(13.0));
        
    }];
    
    //包邮
    self.freightBtn = [UIButton buttonWithTitle:@"包邮" titleColor:kTextColor backgroundColor:[UIColor colorWithHexString:@"#f2f3f7"] titleFont:13.0 cornerRadius:2.5];
    
    [self.freightBtn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
    
    [self.freightBtn setBackgroundColor:[UIColor colorWithHexString:@"#eaf6fe"] forState:UIControlStateSelected];
    
    [self.freightBtn addTarget:self action:@selector(clickFreight:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.freightBtn];
    [self.freightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftMargin);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(textLbl.mas_bottom).mas_equalTo(17);
        
    }];
    
    //全新
    self.freshBtn = [UIButton buttonWithTitle:@"全新" titleColor:kTextColor backgroundColor:[UIColor colorWithHexString:@"#f2f3f7"] titleFont:13.0 cornerRadius:2.5];
    
    
    [self.freshBtn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
    
    [self.freshBtn setBackgroundColor:[UIColor colorWithHexString:@"#eaf6fe"] forState:UIControlStateSelected];
    
    [self.freshBtn addTarget:self action:@selector(clickFresh:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.freshBtn];
    [self.freshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.freightBtn.mas_right).mas_equalTo(leftMargin);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(textLbl.mas_bottom).mas_equalTo(17);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    line.tag = 2000;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftMargin);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.freightBtn.mas_bottom).mas_equalTo(15);
        
    }];
}

- (void)initCenterView {
    
    CGFloat leftMargin = 10;
    
    UIView *line = (UIView *)[self viewWithTag:2000];
    //
    UILabel *textLbl = [UILabel labelWithText:@"价格范围（元）" textColor:kTextColor textFont:13.0];
    
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(line.mas_bottom).mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_equalTo(kFontHeight(13.0));
        
    }];
    
    //最低价
    self.minPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero leftTitle:@"" titleWidth:0 placeholder:@"最低价"];
    
    self.minPriceTF.textAlignment = NSTextAlignmentCenter;
    
    self.minPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.minPriceTF.layer.borderWidth = 1;
    self.minPriceTF.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.maxPriceTF.layer.cornerRadius = 2.5;
    self.maxPriceTF.clipsToBounds = YES;
    
    [self addSubview:self.minPriceTF];
    [self.minPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftMargin);
        make.top.mas_equalTo(textLbl.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(30);
        
    }];
    
    //间隔
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.minPriceTF.mas_right).mas_equalTo(5);
        make.width.mas_equalTo(12.5);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self.minPriceTF.mas_centerY);
        
    }];
    
    //最高价
    self.maxPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero leftTitle:@"" titleWidth:0 placeholder:@"最高价"];
    
    self.maxPriceTF.textAlignment = NSTextAlignmentCenter;
    self.maxPriceTF.keyboardType = UIKeyboardTypeNumberPad;

    self.maxPriceTF.layer.borderWidth = 1;
    self.maxPriceTF.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    self.maxPriceTF.layer.cornerRadius = 2.5;
    self.maxPriceTF.clipsToBounds = YES;
    
    self.maxPriceTF.delegate = self;
    
    [self addSubview:self.maxPriceTF];
    [self.maxPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(5);
        make.top.mas_equalTo(self.minPriceTF.mas_top);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(30);
        
    }];
    
    self.btnArr = [NSMutableArray array];
    
    //价格选择
    self.priceArr = @[@"100元以下", @"300元以下", @"500元以下", @"1000元以下", @"2000元以下", @"3000元以下"];
    
    [self.priceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger count = 3;

        CGFloat btnW = (kScreenWidth*0.8 - 40)/(count*1.0);
        
        UIButton *btn = [UIButton buttonWithTitle:obj titleColor:kTextColor backgroundColor:[UIColor colorWithHexString:@"#f2f3f7"] titleFont:13.0 cornerRadius:2.5];
        
        btn.tag = 1500 + idx;
        
        [btn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
        
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf6fe"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(selectPrice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(leftMargin + (idx%count)*(btnW + 10));
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.minPriceTF.mas_bottom).mas_equalTo(15 + idx/count*40);
            
        }];
        
        [self.btnArr addObject:btn];
    }];
}

- (void)initBottomView {
    
    //重置
    self.resetBtn = [UIButton buttonWithTitle:@"重置" titleColor:kTextColor2 backgroundColor:[UIColor colorWithHexString:@"#f2f3f7"] titleFont:16.0];
    
    [self.resetBtn addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
        
    }];
    
    //确认
    self.confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0];
    
    [self.confirmBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.resetBtn.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
        
    }];
}

#pragma mark - Events
- (void)clickFreight:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.isFreight = sender.selected;

}

- (void)clickFresh:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.isNew = sender.selected;
}

- (void)selectPrice:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 1500;
    
    self.minPriceTF.text = nil;
    self.maxPriceTF.text = nil;
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = sender.tag == obj.tag ? YES: NO;
        
    }];
    
    NSArray *priceArr = @[@"100", @"300", @"500", @"1000", @"2000", @"3000"];
    
    self.maxPrice = priceArr[index];
    
}
//重置
- (void)clickReset:(UIButton *)sender {
    
    self.isNew = NO;
    self.isFreight = NO;
    
    self.freightBtn.selected = NO;
    self.freshBtn.selected = NO;
    self.minPriceTF.text = nil;
    self.maxPriceTF.text = nil;
    
    self.maxPrice = nil;
    self.minPrice = nil;
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = NO;
    }];
}

- (void)clickConfirm:(UIButton *)sender {
    
    FilterManager *manager = [FilterManager manager];
    
    manager.minPrice = self.minPrice;
    
    manager.maxPrice = self.maxPrice;
    
    manager.isNew = self.isNew;
    
    manager.isFreight = self.isFreight;
    
    manager.isAsc = YES;
    
    if (_confirmBlock) {
        
        _confirmBlock();
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = NO;
    }];
    
}

@end
