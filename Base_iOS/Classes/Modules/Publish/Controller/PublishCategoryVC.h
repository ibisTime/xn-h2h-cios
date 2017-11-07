//
//  PublishCategoryVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "PublishCategoryModel.h"

typedef void(^PublishCategoryBlock)(PublishCategoryModel *category);

@interface PublishCategoryVC : BaseViewController

@property (nonatomic, copy) PublishCategoryBlock categoryBlock;

@end
