//
//  CDGoodsParameterChooseView.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHStepView.h"

@class CDGoodsParameterModel;
@class CDGoodsParameterChooseView;

typedef NS_ENUM(NSUInteger, GoodsParameterChooseType) {
     
    GoodsParameterChooseCancle = 0,
    GoodsParameterChooseConfirm
     
};

typedef NS_ENUM(NSInteger, GoodsBtnType) {

    GoodsBtnTypeAddToCart = 0,
    GoodsBtnTypeBuy,
};

@protocol GoodsParameterChooseDelegate <NSObject>

- (void)finishChooseWithType:(GoodsParameterChooseType)type btnType:(GoodsBtnType)btnType chooseView:(CDGoodsParameterChooseView *)chooseView parameter:(CDGoodsParameterModel *)parameterModel count:(NSInteger)count;

@end

@interface CDGoodsParameterChooseView : UIControl

@property (nonatomic, weak) id<GoodsParameterChooseDelegate> delegate;

@property (nonatomic, assign) GoodsBtnType btnType;

@property (nonatomic, copy) NSString *coverImageUrl;

@property (nonatomic, strong) ZHStepView *stepView;

+ (instancetype)chooseView;

- (void)show;
- (void)dismiss;

- (void)loadArr:(NSArray <CDGoodsParameterModel *>*)strArr;

@end
