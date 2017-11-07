//
//  RechargeTableView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/30.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "RechargeTableView.h"
#import "RechargeCell.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@interface RechargeTableView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UILabel *balanceLabel;

@property (nonatomic, strong) NSMutableArray *btnArr;
//支付方式
@property (nonatomic, strong) NSArray *payArr;
//图片
@property (nonatomic, strong) NSArray *imgArr;
//文字
@property (nonatomic, strong) NSArray *textArr;

@end

@implementation RechargeTableView

{
    RechargeCellBlock _cellBlock;
}

static NSString *reuseIdentifierCell = @"reuseIdentifierCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellBlock:(RechargeCellBlock)cellBlock {
    if (self = [super initWithFrame:frame style:style]) {
        
        _cellBlock = [cellBlock copy];
        
        self.btnArr = [NSMutableArray array];
        
        //    self.imgArr = @[@"wx_pay",@"alipay"];
        //
        //    self.textArr = @[@"微信支付",@"支付宝支付"];
        
        //    self.payArr = @[@(PayTypeWxPay), @(PayTypeAlipay)];
        
        self.payArr = @[@(PayTypeWxPay)];
        
        self.imgArr = @[@"wx_pay"];
        
        self.textArr = @[@"微信支付"];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = kBackgroundColor;
        
        [self registerClass:[RechargeCell class] forCellReuseIdentifier:reuseIdentifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.payArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    
    cell.imgStr = self.imgArr[indexPath.row];
    cell.payName = self.textArr[indexPath.row];
    
    cell.payBtn.tag = 1400 + indexPath.row;
    
    [self.btnArr addObject:cell.payBtn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIButton *btn in self.btnArr) {
        
        btn.selected = btn.tag == 1400 + indexPath.row ? YES: NO;
//        btn.selected = !btn.selected;
        
    }
    
    if (_cellBlock) {
        
        _cellBlock(indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (![string isEqualToString:@""]) {
        
        _promptLabel.hidden = YES;
        
    }else {
        
        if (range.location == 0) {
            
            _promptLabel.hidden = NO;
        }
    }
    
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
        if (textField.text.length >= 9) {  //小数点前面6位
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
