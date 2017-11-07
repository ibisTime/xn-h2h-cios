//
//  ShopTypeView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ShopTypeView.h"

#import "ShopViewButton.h"
#import "UIButton+WebCache.h"

@interface ShopTypeView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageCtrl;

@property (nonatomic,strong) NSMutableArray <ShopViewButton *>*shopTypeButtomRooms;

@property (nonatomic, assign) CGFloat scrollHeight;

@end

@implementation ShopTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initScrollView];
        
        [self initPageControl];
        
    }
    return self;
}

#pragma mark - Init
- (NSMutableArray<ShopViewButton *> *)shopTypeButtomRooms {
    
    if (!_shopTypeButtomRooms) {
        
        _shopTypeButtomRooms = [[NSMutableArray alloc] init];
    }
    
    return _shopTypeButtomRooms;
    
}

- (void)initScrollView {
    
    CGFloat h = (kScreenWidth - 1.5)/4.0;

    CGFloat margin = 0.5;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];

}

- (void)initPageControl {
    
    UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.yy + 1, 20, 20)];
    pageCtrl.backgroundColor = [UIColor whiteColor];
    pageCtrl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
    pageCtrl.currentPageIndicatorTintColor = kAppCustomMainColor;
    
    [self addSubview:pageCtrl];
    self.pageCtrl = pageCtrl;
}

#pragma mark - Setting
- (void)setTypeModels:(NSArray<ShopTypeModel *> *)typeModels {
    
    _typeModels = typeModels;
    
    //先移除原来的
    if (self.shopTypeButtomRooms.count > 0) {
        
        [self.shopTypeButtomRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.shopTypeButtomRooms removeAllObjects];
    }
    
    //计算几页
    NSInteger pageCount = typeModels.count/9 + 1;
    //
    NSInteger index = typeModels.count < 9 ? (typeModels.count/5 + 1): 2;
    
    _scrollHeight = index*(kScreenWidth - 1.5)/4.0;
    
    self.pageCtrl.numberOfPages = pageCount;
    //        [self.shopTypePageCtrl updateCurrentPageDisplay];
    self.pageCtrl.defersCurrentPageDisplay = YES;
    self.pageCtrl.hidden = pageCount == 1 ? YES: NO;
    
    CGRect frame = self.scrollView.frame;
    
    self.scrollView.contentSize = CGSizeMake(pageCount*kScreenWidth, _scrollHeight);
    
    self.scrollView.frame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, _scrollHeight);
    
    //3.然后添加新的
    CGFloat margin = 0;
    
    //
    CGFloat w = (kScreenWidth - 3*margin)/4.0;
    CGFloat h = w;
    NSInteger modulesNum = typeModels.count > 4? 8: 4;
    
    BaseWeakSelf;
    
    for (NSInteger i = 0; i < typeModels.count; i ++) {
        
        //i 无要求
        CGFloat x = (w + margin)*(i%4) + kScreenWidth *(i/modulesNum);
        
        CGFloat y = (h + margin)*((i - modulesNum*(i/modulesNum))/4) + 0.5;
        
        ShopViewButton *shopTypeBtn = [[ShopViewButton alloc] initWithFrame:CGRectMake(x, y, w, h)
                                                                funcName:typeModels[i].name];
        [self.scrollView addSubview:shopTypeBtn];
        
        [shopTypeBtn.funcBtn sd_setImageWithURL:[NSURL URLWithString:[typeModels[i].pic convertImageUrl]] forState:UIControlStateNormal];
        shopTypeBtn.index = i;
        shopTypeBtn.selected = ^(NSInteger index) {
            
            if (weakSelf.typeBlock) {
                
                weakSelf.typeBlock(typeModels[index].code, index);
            }
            
        };
        
        [self.shopTypeButtomRooms addObject:shopTypeBtn];
        
    }
    
    self.pageCtrl.y = _scrollHeight + 1;
    
    CGFloat y = pageCount == 1 ? self.scrollView.yy + 1: self.scrollView.yy + 21;
    
    self.height = y;
}

#pragma mark- scrollViewDidscroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.scrollView]) {
        
        self.pageCtrl.currentPage = scrollView.contentOffset.x/self.scrollView.width;
        
    }
}

@end
