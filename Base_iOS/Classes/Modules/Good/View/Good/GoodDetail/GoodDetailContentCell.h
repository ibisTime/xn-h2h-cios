//
//  GoodDetailContentCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailLayoutItem.h"

#import "UserPhotoView.h"

typedef NS_ENUM(NSInteger, GoodDetailEventsType) {
    
    GoodDetailEventsTypeHeadIcon = 0,
    GoodDetailEventsTypeShowTitle,

};

@protocol GoodDetailCellDelegate <NSObject>

- (void)didSelectActionWithType:(GoodDetailEventsType)type index:(NSInteger)index;

@end

@interface GoodDetailContentCell : UITableViewCell

@property (nonatomic, assign) BOOL isCurrentUser;

@property (nonatomic, strong) UserPhotoView *photoImageView;

@property (nonatomic, weak) id <GoodDetailCellDelegate>delegate;

@property (nonatomic, strong) GoodDetailLayoutItem *layoutItem;

@property (nonatomic, strong) TLUser *user;

@end
