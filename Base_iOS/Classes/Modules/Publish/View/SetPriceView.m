//
//  SetPriceView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SetPriceView.h"
#import "CustomDecimalKeyboard.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface SetPriceView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
//现价
@property (nonatomic, strong) TLTextField *priceTF;
//原价
@property (nonatomic, strong) TLTextField *originPriceTF;
//运费
@property (nonatomic, strong) TLTextField *freightTF;
//包邮
@property (nonatomic, strong) UIButton *freightBtn;

@end

@implementation SetPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    BaseWeakSelf;
    
    self.alpha = 0;

    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];
    
    CustomDecimalKeyboard *inputView = [[CustomDecimalKeyboard alloc] init];
    
    inputView.done = ^{
        
        [weakSelf hide];
    };
    
    //背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 160 - inputView.height, kScreenWidth, 160)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bgView];
    
    //现价
    UILabel *textLbl = [UILabel labelWithText:@"想卖多少钱?" textColor:kTextColor textFont:12.0];
    
    textLbl.frame = CGRectMake(15, 10, 150, 12);
    
    [self.bgView addSubview:textLbl];
    
    self.priceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, textLbl.yy, kScreenWidth - 30, 38) leftTitle:@"" titleWidth:15 placeholder:@"￥0"];
    
    self.priceTF.font = Font(18.0);
    self.priceTF.textColor = kTextColor;
    
    self.priceTF.delegate = self;
    self.priceTF.clearButtonMode = UITextFieldViewModeNever;
    self.priceTF.inputView = inputView;
    [self.priceTF reloadInputViews];
    self.priceTF.returnKeyType = UIReturnKeyNext;
    
    [self.bgView addSubview:self.priceTF];
    
    //原价
    
    self.originPriceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.priceTF.yy, kScreenWidth - 30, 50) leftTitle:@"原价" titleWidth:65 placeholder:@"￥0"];
    
    self.originPriceTF.font = Font(14.0);
    self.originPriceTF.textColor = kTextColor;
    
    self.originPriceTF.delegate = self;
    self.originPriceTF.clearButtonMode = UITextFieldViewModeNever;
    self.originPriceTF.inputView = inputView;
    [self.originPriceTF reloadInputViews];
    self.originPriceTF.returnKeyType = UIReturnKeyNext;

    [self.bgView addSubview:self.originPriceTF];
    //运费
    self.freightTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.originPriceTF.yy, 200, 50) leftTitle:@"运费" titleWidth:65 placeholder:@"待议"];
    
    self.freightTF.font = Font(14.0);
    self.freightTF.textColor = kTextColor;
    
    self.freightTF.delegate = self;
    self.freightTF.clearButtonMode = UITextFieldViewModeNever;
    self.freightTF.inputView = inputView;
    [self.freightTF reloadInputViews];
    self.freightTF.returnKeyType = UIReturnKeyDone;

    [self.bgView addSubview:self.freightTF];
    //包邮
    UIButton *freightBtn = [UIButton buttonWithTitle:@"包邮" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:14.0];
    
    [freightBtn addTarget:self action:@selector(clickFreight:) forControlEvents:UIControlEventTouchUpInside];
    
    freightBtn.frame = CGRectMake(self.freightTF.xx, self.originPriceTF.yy, 100, 50);
    //
    [freightBtn setImage:kImage(@"发布_未选中") forState:UIControlStateNormal];
    
    [freightBtn setImage:kImage(@"发布_选中") forState:UIControlStateSelected];
    
    [freightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.bgView addSubview:freightBtn];
    
    self.freightBtn = freightBtn;

    for (int i = 0; i < 3; i++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + i*50, kScreenWidth, 1)];
        
        line.backgroundColor = kLineColor;
        
        [self.bgView addSubview:line];
    }
}

#pragma mark - Setting
- (void)setPriceModel:(PriceModel *)priceModel {
    
    _priceModel = priceModel;
    
    _priceTF.text = _priceModel.price;
    
    _originPriceTF.text = _priceModel.originPrice;
    
    _freightTF.text = _priceModel.freightFee;
    
    self.freightBtn.selected = [_priceModel.freightFee isEqualToString:@"0"] ? YES: NO;
    
    self.freightTF.enabled = self.freightBtn.selected ? NO: YES;

}

- (void)setFreightType:(NSString *)freightType {
    
    _freightType = freightType;
    
    if ([self.freightType isEqualToString:@"2"]) {
        
        self.freightBtn.userInteractionEnabled = NO;
        
        self.freightBtn.selected = YES;
        
        self.freightTF.text = @"0";
    }
}

#pragma mark - Events

- (void)clickFreight:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.freightTF.text = sender.selected ? @"0": @"";
    
    self.freightTF.enabled = sender.selected ? NO: YES;

}

- (void)show {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [self.priceTF becomeFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    } completion:^(BOOL finished) {
        
        PriceModel *price = [PriceModel new];
        
        if (self.priceTF.text.length != 0) {
            
            price.price = self.priceTF.text;
        }
        
        if (self.originPriceTF.text.length != 0) {
            
            price.originPrice = self.originPriceTF.text;
        }
        
        if (self.freightTF.text.length != 0) {
            
            price.freightFee = self.freightTF.text;
        }
        
        if (_done) {
            
            _done(price);
        };
        
        [self removeFromSuperview];

    }];
    

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self hide];
//}

#pragma mark - UITextFieldDelegate
/// 设置自定义键盘后，delegate 不会被调用？
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if (![string isEqualToString:@""]) {
//
//        _promptLabel.hidden = YES;
//
//    }else {
//
//        if (range.location == 0) {
//
//            _promptLabel.hidden = NO;
//        }
//    }
    
    if ([string isEqualToString:@"\n"] || [string isEqualToString:@""]) {//按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        
        NSInteger count = textField != _freightTF ? 6: 3;
        
        NSString *promptStr = textField != _freightTF ? @"价格不能超过999999哦": @"运费不能超过999哦";
        
        if (textField.text.length >= count) {  //小数点前面6位
            
            [TLAlert alertWithInfo:promptStr];
            return NO;
        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        if (textField.text.length >= 12) {
            return NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {
        return NO;  //小数点后面两位
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc && [string isEqualToString:@"."]) {
        return NO;  //控制只有一个小数点
    }
    return YES;
}

@end
