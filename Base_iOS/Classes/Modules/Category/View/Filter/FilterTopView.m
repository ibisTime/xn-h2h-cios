//
//  FilterTopView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterTopView.h"

#import "FilterConditionView.h"

@interface FilterTopView ()

//筛选
@property (nonatomic, strong) FilterConditionView *conditionView;
//向上
@property (nonatomic, strong) UIButton *upBtn;
//向下
@property (nonatomic, strong) UIButton *downBtn;

@end

@implementation FilterTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
        
    }
    return self;
}

#pragma mark - Init

- (void)initSubviews {

    NSString *categoryName = [FilterManager manager
                              ].category ? [FilterManager manager
                                            ].category.name: @"全部";
    
    NSArray *textArr = @[@"全国", categoryName, @"价格", @"筛选"];
    
    NSInteger count = 4;
    
    CGFloat btnW = self.width/(count*1.0);
    
    CGFloat btnH = self.height;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //区域
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
        
        [btn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 1300 + idx;
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(idx*btnW);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            
        }];
        
        //Text
        UILabel *textLbl = [UILabel labelWithText:textArr[idx] textColor:kTextColor textFont:14.0];
        
        textLbl.tag = 1310 + idx;
        
        [self addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(btn.mas_centerX);
            make.width.mas_lessThanOrEqualTo(btnW - 15 - 6 - 8);
            make.height.mas_equalTo(btnH);
            
        }];
        
        //imageView
        if (idx == 0) {
            
            UIButton *areaArrowBtn = [UIButton buttonWithImageName:@"下拉-灰色" selectedImageName:@"下拉"];
            
            [areaArrowBtn setImage:kImage(@"下拉") forState:UIControlStateHighlighted];
            
            areaArrowBtn.tag = 1320;
            
            [self addSubview:areaArrowBtn];
            [areaArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(textLbl.mas_right).mas_equalTo(6);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(5);
                make.centerY.mas_equalTo(0);
                
            }];
            
        } else if (idx == 2) {
            
            self.upBtn = [UIButton buttonWithImageName:@"上拉-灰色" selectedImageName:@"上拉"];
            
            [self addSubview:self.upBtn];
            [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(textLbl.mas_right).mas_equalTo(6);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(5);
                make.bottom.mas_equalTo(self.mas_centerY).mas_equalTo(-1);

            }];
            
            
            self.downBtn = [UIButton buttonWithImageName:@"下拉-灰色" selectedImageName:@"下拉"];
            
            [self addSubview:self.downBtn];
            [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(textLbl.mas_right).mas_equalTo(6);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(5);
                make.top.mas_equalTo(self.mas_centerY).mas_equalTo(1);
                
            }];
            
        } else if (idx == 3) {
            
            UIButton *filterBtn = [UIButton buttonWithImageName:@"筛选"];
            
            [self addSubview:filterBtn];
            [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(textLbl.mas_right).mas_equalTo(6);
                make.width.mas_equalTo(11);
                make.height.mas_equalTo(12);
                make.centerY.mas_equalTo(0);
                
            }];
        }
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
}

- (FilterAddressView *)addressView {

    if (!_addressView) {
        
        BaseWeakSelf;
        
        _addressView = [[FilterAddressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 40, kScreenWidth, kSuperViewHeight)];
        
        _addressView.done = ^() {
            
            FilterManager *filter = [FilterManager manager];
            
            [weakSelf filterGood];
            
            UILabel *lbl = (UILabel *)[weakSelf viewWithTag:1310];
            
            UIButton *btn = (UIButton *)[weakSelf viewWithTag:1300];

            UIButton *arrowbtn = (UIButton *)[weakSelf viewWithTag:1320];

            if (filter.area) {
                
                lbl.text = filter.area;
                
            } else {
                
                lbl.text = @"全国";
            }
            
            lbl.textColor = kTextColor;
            
            btn.selected = NO;
            
            arrowbtn.selected = NO;
        };
        
    }
    
    return _addressView;
}

- (FilterCategoryView *)categoryView {
    
    if (!_categoryView) {
        
        BaseWeakSelf;
        
        _categoryView = [[FilterCategoryView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 50, kScreenWidth, kSuperViewHeight)];
        
        _categoryView.done = ^() {
          
            FilterManager *filter = [FilterManager manager];

            UILabel *lbl = (UILabel *)[weakSelf viewWithTag:1311];

            lbl.text = filter.category.name;
            
            lbl.textColor = kTextColor;
            
            [weakSelf filterGood];
            //隐藏视图
            [weakSelf.categoryView hide];

        };
    }
    
    return _categoryView;
}

- (FilterConditionView *)conditionView {
    
    if (!_conditionView) {
        
        BaseWeakSelf;
        
        _conditionView = [[FilterConditionView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        //确认
        _conditionView.done = ^{
            
            UIButton *btn = (UIButton *)[weakSelf viewWithTag:1303];
            
            btn.selected = NO;
            
            [weakSelf filterGood];
        };
        
        _conditionView.conditionHide = ^{
            
            UIButton *btn = (UIButton *)[weakSelf viewWithTag:1303];
            
            btn.selected = NO;
        };
    }
    
    return _conditionView;
}

#pragma mark - Events
- (void)filter:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 1300;
    
    UIButton *arrowBtn = (UIButton *)[self viewWithTag:1320];

    UILabel *lbl = (UILabel *)[self viewWithTag:1311];

    switch (index) {
        case 0:
        {
            arrowBtn.selected = sender.selected;
            
            UILabel *lbl = (UILabel *)[self viewWithTag:1310];
            
            if (sender.selected) {
                
                lbl.textColor = kAppCustomMainColor;
                
                [self.addressView show];
            
//                [self.categoryView hide];
                
            } else {
                
                lbl.textColor = kTextColor;

                [self.addressView hide];
            }
            
        }break;
            
        case 1:
        {

            if (sender.selected) {
                
                lbl.textColor = kAppCustomMainColor;
                
                
                [self.categoryView show];
                
//                [self.addressView hide];

            } else {
                
                lbl.textColor = kTextColor;

                [self.categoryView hide];
            }
            
        }break;
            
        case 2:
        {
            
            if (sender.selected) {
                
                self.upBtn.selected = NO;
                
                self.downBtn.selected = YES;
                
            } else {
                
                self.upBtn.selected = YES;
                
                self.downBtn.selected = NO;
            }
            
            FilterManager *filter = [FilterManager manager];

            filter.isAsc = !sender.selected;
            
            [self filterGood];
            
        }break;
            
        case 3:
        {
            
            if (sender.selected) {
                
                [self.conditionView show];
            }
            
        }break;
            
        default:
            break;
    }

}

- (void)filterGood {
    
    if (_filterBlock) {
        
        _filterBlock();
    }
}

@end
