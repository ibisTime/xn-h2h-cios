//
//  SelectView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/18.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "SelectView.h"
#import "UIView+Responder.h"

#define kHeadBarHeight 40

@interface SelectView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, strong) UIView *headView;

//底部线条
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) CGFloat leftLength;

@end

@implementation SelectView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles {

    if (self = [super initWithFrame:frame]) {
        
        _itemTitles = itemTitles;
        
        _btnArray = [NSMutableArray array];
        
        [self initTopView];
        
        [self initScrollView];
        
    }
    
    return self;
}


#pragma mark - Init

- (void)initTopView {

    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self addSubview:_headView];
    
    CGFloat w = kScreenWidth/(_itemTitles.count*1.0);
    
    for (int i = 0; i < _itemTitles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithTitle:_itemTitles[i] titleColor:kBlackColor backgroundColor:kClearColor titleFont:14.0];
        
        btn.tag = 1200 + i;
        
        btn.selected = i == 0? YES: NO;
        
        [btn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(w*i);
            make.width.mas_equalTo(w);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kHeadBarHeight);
            
        }];
        
        [_btnArray addObject:btn];
    }
    
    UIView *lineView = [[UIView alloc] init];
    
    [_headView addSubview:lineView];
    
    _lineView = lineView;
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [_headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kLineHeight);
        
    }];
}

- (void)initScrollView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeadBarHeight, kScreenWidth, kSuperViewHeight - kHeadBarHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _itemTitles.count, kSuperViewHeight - kHeadBarHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    [self insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self addSubview:_scrollView];
}

#pragma mark - Settings

- (void)setTitlePropertyWithTitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor {

    for (UIButton *btn in _btnArray) {
        
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
        
        btn.titleLabel.font = titleFont;

    }

}

- (void)setLinePropertyWithLineColor:(UIColor *)lineColor lineSize:(CGSize)lineSize {

    _lineView.backgroundColor = lineColor;
    
    CGFloat length = kScreenWidth/(_itemTitles.count*2.0);
    
    CGFloat leftLength = length - lineSize.width/2.0;
    
    _leftLength = leftLength;
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftLength);
        make.height.mas_equalTo(lineSize.height);
        make.width.mas_equalTo(lineSize.width);
        make.bottom.mas_equalTo(0);
        
    }];

}

#pragma mark - Events

- (void)clickBtn:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 1200;
    
    CGPoint point = CGPointMake(index*kScreenWidth, _scrollView.contentOffset.y);
    //线条偏移量
    CGFloat x = kScreenWidth/(_itemTitles.count*1.0)*index + _leftLength;
    
    for (UIButton *btn in _btnArray) {
        
        btn.selected = sender.tag == btn.tag ? YES: NO;
    }
    
    //滚动
    [UIView animateWithDuration:0.5 animations:^{
        
        [_lineView setX:x];
        
        [_scrollView setContentOffset:point];

    }];
    
    if (_selectBlock) {
        
        _selectBlock(index);
    }
}

@end
