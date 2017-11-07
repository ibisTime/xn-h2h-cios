//
//  ShopViewButton.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ShopViewButton.h"

@implementation ShopViewButton

- (instancetype)initWithFrame:(CGRect)frame funcName:(NSString *)funcName {
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgView = self;
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (kScreenWidth/4.0 - 50)/2.0, 40, 40)];
        
        [funcBtn setEnlargeEdge:20];
        [bgView addSubview:funcBtn];
        funcBtn.centerX = bgView.width/2.0;
        [funcBtn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.funcBtn = funcBtn;
        
        CGFloat h = [[UIFont thirdFont] lineHeight];
        
        UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:Font(kWidth(13)) textColor:kTextColor];
        nameLbl.centerX = funcBtn.centerX;
        nameLbl.text = funcName;
        [bgView addSubview:nameLbl];
        
        CGFloat margin = 0.5;
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.width - margin, 0, margin, bgView.height)];
        
        rightLine.backgroundColor = kLineColor;
        
        [bgView addSubview:rightLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.height - margin, bgView.width, margin)];
        
        bottomLine.backgroundColor = kLineColor;
        
        [bgView addSubview:bottomLine];
    }
    
    return self;
    
}

//--//
- (void)selectedAction {
    
    if (self.selected) {
        self.selected(self.index);
    }
    
}

@end
