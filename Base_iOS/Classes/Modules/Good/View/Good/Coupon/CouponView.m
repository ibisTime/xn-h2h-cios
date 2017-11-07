//
//  CouponView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/19.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CouponView.h"
#import "CouponCell.h"

@interface CouponView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;
//确定
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSMutableArray <UIButton *>*btnArr;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CouponView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.btnArr = [[NSMutableArray alloc] init];
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init

- (void)initSubviews {
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];
    
    //背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kHeight(418 + kBottomInsetHeight), kScreenWidth, kHeight(418 + kBottomInsetHeight))];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bgView];
    
    //text
    UILabel *textLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth, 50) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(16.0) textColor:kTextColor];
    
    textLbl.text = @"优惠券抵用";
    
    [self.bgView addSubview:textLbl];
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, textLbl.yy, kScreenWidth, kHeight(418) - textLbl.height - 45 - 40) delegate:self dataSource:self];
    
    [self.tableView registerClass:[CouponCell class] forCellReuseIdentifier:@"CouponCellId"];
    
    [self.bgView addSubview:self.tableView];
    //确定
    self.confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18.0 cornerRadius:5];
    
    [self.confirmBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn.frame = CGRectMake(15, self.tableView.yy + 20, kScreenWidth - 2*15, 45);
    
    [self.bgView addSubview:self.confirmBtn];
    
}

#pragma mark - Events

- (void)clickConfirm:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (_done) {
        
        _done(self.currentIndex);
        
        [self hide];
    }
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - UITableViewSatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.coupons.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *couponCellId = @"CouponCellId";

    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellId forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.textLbl.text = @"不使用优惠券";
        
    } else {
        
        cell.coupon = self.coupons[indexPath.row - 1];

    }
    
    if (indexPath.row == 1) {
        
        cell.selectedBtn.selected = YES;

        self.currentIndex = 1;
        
    }else {
        
        cell.selectedBtn.selected = NO;
    }
    
    [self.btnArr addObject:cell.selectedBtn];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = idx == indexPath.row ? YES: NO;
        
    }];
    
    self.currentIndex = indexPath.row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
