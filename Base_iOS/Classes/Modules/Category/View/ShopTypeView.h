//
//  ShopTypeView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopTypeModel.h"

typedef void(^ShopTypeBlock)(NSString *code, NSInteger index);

@interface ShopTypeView : UIView

@property (nonatomic, strong) NSArray <ShopTypeModel *>*typeModels;

@property (nonatomic, copy) ShopTypeBlock typeBlock;

@end
