//
//  FilterAddressView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterManager.h"

typedef void(^FilterAddressDone)();

@interface FilterAddressView : UIView

@property (nonatomic, copy) FilterAddressDone done;

- (void)show;

- (void)hide;

@end
