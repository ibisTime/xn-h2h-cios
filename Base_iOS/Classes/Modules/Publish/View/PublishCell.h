//
//  PublishCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UISwitch *sw;

@property (nonatomic, assign) BOOL arrowHidden;

@property (nonatomic, assign) BOOL switchHidden;

@end
