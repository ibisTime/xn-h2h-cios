//
//  CircleCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
#import "UserPhotoView.h"

@interface CircleCell : UITableViewCell

@property (nonatomic, strong) GoodModel *goodModel;
//头像
@property (nonatomic, strong) UserPhotoView *photoImageView;

@end
