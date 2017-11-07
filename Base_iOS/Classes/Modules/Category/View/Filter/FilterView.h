//
//  FilterView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterConfirmBlock)();

@interface FilterView : UIView

@property (nonatomic, copy) FilterConfirmBlock confirmBlock;

@end
