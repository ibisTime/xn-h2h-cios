//
//  FilterConditionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterConditionView.h"
#import "FilterManager.h"
#import "FilterView.h"

@interface FilterConditionView ()<UIGestureRecognizerDelegate>
//背景
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) FilterView *filterView;

@end

@implementation FilterConditionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //
        [self initFilterView];
        
        [self addGestureRecognizer];
    }
    
    return self;
}

#pragma mark - Init
- (void)initFilterView {
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];

    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.bgView];
    
    [self addSubview:self.filterView];

}

- (FilterView *)filterView {
    
    if (!_filterView) {
        
        BaseWeakSelf;
        
        _filterView = [[FilterView alloc] init];
        
        _filterView.frame = CGRectMake(0.2*self.width, 0, self.width * 0.8, self.height);
        
        _filterView.userInteractionEnabled = YES;
        
        _filterView.backgroundColor = kWhiteColor;
        
        _filterView.confirmBlock = ^{
          
            if (weakSelf.done) {
                //刷新商品列表
                weakSelf.done();
                //隐藏
                [weakSelf hide];
    
            };
        };
    }
    return _filterView;
}

- (void)addGestureRecognizer {
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)]; //滑动
    pan.delegate = self;
    
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    
    [self.bgView addGestureRecognizer:tap];
    
}

#pragma mark - Events
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        
        if (self.conditionHide) {
            
            self.conditionHide();
        }
        
        self.filterView.x = self.width*0.2;
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - 滑动手势事件
- (void)panEvent:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self];
    
    if(UIGestureRecognizerStateBegan == recognizer.state || UIGestureRecognizerStateChanged == recognizer.state){
        
        if (translation.x > 0) {//右滑
            
            self.filterView.x = self.width * 0.2 + translation.x;
            
        }else{//左滑
            
            if (self.filterView.x < self.width * 0.2) {
                
                self.filterView.x = self.filterView.x - translation.x;
            }else{
                
                self.filterView.x = self.width * 0.2;
            }
        }
        
    }else{
        
        [self hide];
    }
}

- (void)tapEvent {
    
    [self hide];
}

@end
