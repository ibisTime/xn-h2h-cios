//
//  SetPriceView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceModel.h"

typedef void(^SetPriceDone)(PriceModel *priceModel);

@interface SetPriceView : UIView

@property (nonatomic, copy) SetPriceDone done;

@property (nonatomic, strong) PriceModel *priceModel;
//包邮活动
@property (nonatomic, strong) NSString *freightType;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
