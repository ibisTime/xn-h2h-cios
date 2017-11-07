//
//  CustomTabBar.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "CustomTabBar.h"

#import "UIButton+WebCache.h"
#import "UIView+Custom.h"

#import "BarButton.h"

@interface CustomTabBar ()

@property (nonatomic, strong) UIView *falseTabBar;
@property (nonatomic, strong) NSMutableArray <BarButton *>*btns;

@property (nonatomic, strong) UIImageView *middleImageView;
//未读消息数
@property (nonatomic, strong) UILabel *unReadLbl;
//发布按钮
@property (nonatomic, strong) UIButton *middleBtn;

@end

@implementation CustomTabBar
{
    BarButton *_lastTabBarBtn;
}

- (void)setTabBarItems:(NSArray<TabBarModel *> *)tabBarItems {
    
    _tabBarItems = [tabBarItems copy];
    
    //
    if (_tabBarItems && (_tabBarItems.count == self.btns.count)) {
        
        [_tabBarItems enumerateObjectsUsingBlock:^(TabBarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BarButton *barBtn = self.btns[idx];
            barBtn.titleLbl.text = obj.title;
            
            //图片
            if (barBtn.isCurrentSelected) {
                
                barBtn.iconImageView.image = [UIImage imageNamed:obj.selectedImgUrl];
            } else {
                
                barBtn.iconImageView.image = [UIImage imageNamed:obj.unSelectedImgUrl];
                
            }
            
            
        }];
        
    }
    
}

- (UIView *)falseTabBar {
    
    if (!_falseTabBar) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgRefreh:) name:@"MessageDidRefresh" object:nil];
        
        _falseTabBar = [[UIView alloc] initWithFrame:self.bounds];
        
        _falseTabBar.userInteractionEnabled = YES;
        _falseTabBar.backgroundColor = [UIColor whiteColor];
        _falseTabBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //顶部分割线
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
//
//        line.backgroundColor = [UIColor colorWithHexString:@"dedede"];
//
//        [_falseTabBar addSubview:line];
        
        //添加5个按钮
        
        CGFloat w  = self.width/5.0;
        self.btns = [NSMutableArray arrayWithCapacity:5];
        for (NSInteger i = 0; i < 5; i ++) {
            
            if (i == 2) {
                
                continue;
            }
            
            BarButton *btn = [[BarButton alloc] initWithFrame:CGRectMake(i*w, 0, w, _falseTabBar.height)];
            [_falseTabBar addSubview:btn];
            
            btn.titleLbl.textColor = [UIColor colorWithHexString:@"#484848"];

            [btn addTarget:self action:@selector(hasChoose:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i > 1 ? 100 + i - 1 : 100 + i;
            [self.btns addObject:btn];
            
            if (i == 0) {
                
                _lastTabBarBtn = btn;
                _lastTabBarBtn.selected = YES;
                btn.isCurrentSelected = YES;
                _lastTabBarBtn.titleLbl.textColor = kAppCustomMainColor;
                
            } else if (i == 3) {
                
                _unReadLbl = [UILabel labelWithText:@"" textColor:kWhiteColor textFont:12.0];
                
                _unReadLbl.layer.cornerRadius = 9;
                _unReadLbl.clipsToBounds = YES;
                _unReadLbl.textAlignment = NSTextAlignmentCenter;
                
                _unReadLbl.backgroundColor = kThemeColor;
                
                _unReadLbl.hidden = YES;
                
                [_falseTabBar addSubview:_unReadLbl];
                [_unReadLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.equalTo(btn.mas_centerX).offset(13);
                    make.centerY.equalTo(btn.mas_centerY).offset(-10);
                    make.height.equalTo(@18);
                    make.width.greaterThanOrEqualTo(@18);
                    
                }];
            }
        }
        
        //发布
//        //白色背景
//
//        UIView *whiteView = [UIView new];
//
//        whiteView.backgroundColor = kWhiteColor;
//
//        [_falseTabBar addSubview:whiteView];
//        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_falseTabBar.mas_centerX);
//            make.top.equalTo(_falseTabBar.mas_top).offset(-28);
//            make.width.height.equalTo(@(28));
//
//        }];
        
        //曲线
        
        UIButton *middleBtn = [UIButton buttonWithImageName:@"publish" cornerRadius:28];
        
        middleBtn.backgroundColor = kWhiteColor;
        
        middleBtn.adjustsImageWhenHighlighted = NO;

        [middleBtn addTarget:self action:@selector(selectPublish) forControlEvents:UIControlEventTouchUpInside];
        
        [middleBtn setEnlargeEdgeWithTop:0 right:0 bottom:21 left:0];
        
        [_falseTabBar addSubview:middleBtn];

        [middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_falseTabBar.mas_centerX);
            make.top.equalTo(_falseTabBar.mas_top).offset(-28);
            make.width.height.equalTo(@(56));
            
        }];
        
        middleBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

        self.middleBtn = middleBtn;
        
//        UIImageView * imageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish"]];
//        imageView.userInteractionEnabled = YES;
//        imageView.layer.cornerRadius = 28;
//        imageView.clipsToBounds = YES;
//
//        imageView.contentMode = UIViewContentModeCenter;
//
//        [_falseTabBar addSubview:imageView];
//        self.middleImageView = imageView;
//
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_falseTabBar.mas_centerX);
//            make.top.equalTo(_falseTabBar.mas_top).offset(-28);
//            make.width.height.equalTo(@(56));
//
//        }];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedXiaoMi)];
//        [imageView addGestureRecognizer:tap];
    
        UILabel *titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(11)
                                      textColor:[UIColor colorWithHexString:@"#484848"]];
        titleLbl.text = @"发布";
        
        [_falseTabBar addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleBtn.mas_bottom).offset(4.5);
            make.centerX.equalTo(_falseTabBar.mas_centerX);
            make.width.equalTo(@(w));
            make.height.equalTo(@(13));
        }];
        
    }
    
    return _falseTabBar;
}

- (void)selectPublish {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        if( [self.delegate didSelectedMiddleItemTabBar:self]) {
            
        }
    }
    
}

- (void)drawArc {

    CGContextRef context = UIGraphicsGetCurrentContext();

    //    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度

    CGPoint aPoints[2];

    aPoints[0] = CGPointMake(100, 50);
    aPoints[1] = CGPointMake(130, 50);

    CGContextAddLines(context, aPoints, 2);
}
//
//- (void)drawRect:(CGRect)rect {
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//
//    [path addArcWithCenter:CGPointMake(self.width/2.0, self.middleImageView.yy - 6) radius:28 startAngle:M_PI endAngle:0 clockwise:YES];
//
//    path.lineWidth = 1;
//
//    [[UIColor whiteColor] setStroke];
//
//    [path stroke];
//
//}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self addSubview:self.falseTabBar];
    
}

#pragma mark - Setting
- (void)setSelectedIdx:(NSInteger)selectedIdx {
    
    _selectedIdx = selectedIdx;
    
    [self.btns enumerateObjectsUsingBlock:^(BarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == selectedIdx) {
            
            //上一个选中改变
            _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
            _lastTabBarBtn.isCurrentSelected = NO;
            NSString *lastUrlStr = self.tabBarItems[_lastTabBarBtn.tag - 100].unSelectedImgUrl;
            _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:lastUrlStr];
            
            
            //---//
            //当前选中改变
            obj.titleLbl.textColor = kAppCustomMainColor;
            obj.isCurrentSelected = YES;
            NSString *currentUrlStr = self.tabBarItems[idx].selectedImgUrl;
            obj.iconImageView.image = [UIImage imageNamed:currentUrlStr];
            
            _lastTabBarBtn = obj;
            
            //
            *stop = YES;
            
        }
    }];
    
}

#pragma mark - Events
- (void)msgRefreh:(NSNotification *)notification {
    
    NSInteger msgNum = [notification.object integerValue];
    
    self.unReadLbl.text = [NSString stringWithFormat:@"%ld", msgNum];
    
    self.unReadLbl.hidden = msgNum == 0 ? YES: NO;
    
}

//点击按钮，
- (void)hasChoose:(BarButton *)btn {
    
    if ([_lastTabBarBtn isEqual:btn]) {
        
        return;
    }
    
    //当前选中的小标
    NSInteger idx = btn.tag - 100;
    
    //--//
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        
        if([self.delegate didSelected:idx tabBar:self]) {
            
            [self changeUIWithCurrentSelectedBtn:btn idx:idx];
            
        }
        
    } else {
        
        [self changeUIWithCurrentSelectedBtn:btn idx:idx];
        
    }
    
    
}

- (void)changeUIWithCurrentSelectedBtn:(BarButton *)btn idx:(NSInteger)idx {
    
    _lastTabBarBtn.isCurrentSelected = NO;
    btn.isCurrentSelected = YES;
    
    NSInteger lastIdx = _lastTabBarBtn.tag - 100;
    //上次选中改变图片
    NSString *unselectedStr = self.tabBarItems[lastIdx].unSelectedImgUrl ;
    
    _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:unselectedStr];
    
    _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
    
    //当前选中改变图片
    NSString *selectedStr = self.tabBarItems[idx].selectedImgUrl;
    btn.iconImageView.image = [UIImage imageNamed:selectedStr];
    btn.titleLbl.textColor = kAppCustomMainColor;
    
    //--//
    btn.selected = NO;
    _lastTabBarBtn = btn;
    _lastTabBarBtn.selected = YES;
    
//        else {
//
//        [_unReadLbl mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.equalTo(@5);
//            make.width.greaterThanOrEqualTo(@5);
//        }];
//
//    }
    
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newPoint = [self convertPoint:point toView:self.middleBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.middleBtn pointInside:newPoint withEvent:event]) {
            
            return self.middleBtn;
            
        }else{
            //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    
    else {
        //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}


@end
