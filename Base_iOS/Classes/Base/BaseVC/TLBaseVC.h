//
//  TLBaseVC.h
//  WeRide
//
//  Created by  蔡卓越 on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBaseVC : UIViewController

@property (nonatomic, strong) UIView *tl_placeholderView;

- (UIView *)tl_placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle;
- (void)tl_placeholderOperation;

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)optitle;

- (void)removePlaceholderView; //移除
- (void)addPlaceholderView; // 添加

- (void)showReLoginVC;

@end
