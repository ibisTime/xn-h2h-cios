//
//  FilterConditionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterConditionDone)();

typedef void(^FilterConditionHide)();

@interface FilterConditionView : UIView

@property (nonatomic, copy) FilterConditionDone done;

@property (nonatomic, copy) FilterConditionHide conditionHide;

- (void)show;

- (void)hide;

@end
