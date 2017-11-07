//
//  ZHSegmentView.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2016/12/30.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHSegmentView.h"

@interface ZHSegmentView()

@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIView *bootomLine;


@end

@implementation ZHSegmentView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        
//        CGFloat w = (kScreenWidth - 1.5)/3.0;
//        CGFloat h = 45;
//        CGFloat margin = 0;
//        //
//        
//        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//        NSArray *names = @[@"1",@"2",@"3"];
//        
//        for (NSInteger i = 0; i < names.count; i ++) {
//            
//            CGFloat x = (w + margin)*i;
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, margin, w, h) title:names[i] backgroundColor:[UIColor colorWithHexString:@"#fafafa"]];
//            [self addSubview:btn];
//            
//            btn.tag = 1000 + i;
//            
//            
//            btn.titleLabel.font = [UIFont secondFont];
//            [btn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
//            
//            [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
//            
//            //        if (0 == i) {
//            //            [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            //            self.lastBtn = btn;
//            //        }
//        }
//        [self addSubview:self.bootomLine];
//
//        
//        
//    }
//    return self;
//}


- (void)changeAction:(UIButton *)btn {
    
    if ([self.lastBtn isEqual:btn]) {
        return;
    }
    
    btn.selected = !btn.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSwitch:)]) {
        
        //---//
        
        if ([self.delegate segmentSwitch:btn.tag - 1000]) { //底线跟着切换
            
            [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bootomLine.centerX = btn.centerX;
                
            }];
            
            self.lastBtn.selected = NO;
            
            [self.lastBtn setBackgroundColor:[UIColor colorWithHexString:@"#fafafa"] forState:UIControlStateNormal];
            self.lastBtn = btn;
            
        } else { //底线不切换
            
            
        }
        
    }
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    _selectedIndex = selectedIndex;
    
    UIButton *btn = (UIButton *)[self viewWithTag:1000 + selectedIndex];
    if (btn) {
        [self changeAction:btn];
    }

}

- (void)reloadTagNameWithArray:(NSArray *)tagNames {

    if (!tagNames || tagNames.count <= 0) {
        return;
    }
    //找出按钮,重新赋值
    for (NSInteger i = 0; i < tagNames.count; i++) {
     UIButton *btn =  (UIButton *)[self viewWithTag:1000 + i];
        
        [btn setTitle:tagNames[i] forState:UIControlStateNormal];
        
    }

}


- (void)setTagNames:(NSArray *)tagNames {

    _tagNames = [tagNames copy];
    self.userInteractionEnabled = YES;
    NSInteger count = tagNames.count;
    
    CGFloat w = (kScreenWidth - 1.5)/(count*1.0);
    CGFloat h = self.height;
    CGFloat margin = 0.5;
    //

    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    NSArray *names = _tagNames;
    
    for (NSInteger i = 0; i < names.count; i ++) {
        
        CGFloat x = (w + margin)*i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, h) title:names[i] backgroundColor:[UIColor colorWithHexString:@"#fafafa"]];
        [self addSubview:btn];
        
        btn.tag = 1000 + i;
        btn.titleLabel.font = [UIFont secondFont];
        [btn setTitleColor:[UIColor zh_textColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];

        if (0 == i) {
            
            [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            btn.selected = YES;
            
            self.lastBtn = btn;
        }
    }
    [self addSubview:self.bootomLine];

}


- (UIView *)bootomLine {
    
    if (!_bootomLine) {
        
        _bootomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42.5, (kScreenWidth - 1.5)/(self.tagNames.count*1.0), 3)];
        _bootomLine.backgroundColor = kAppCustomMainColor;
    }
    
    return _bootomLine;
    
}






@end
