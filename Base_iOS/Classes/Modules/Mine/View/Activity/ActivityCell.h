//
//  ActivityCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

typedef NS_ENUM(NSInteger, ActivityEventsType) {
    
    ActivityEventsTypeDetail = 0,
    
};

//@class ActivityCell;
//@protocol ActivityCellDelegate <NSObject>
//
//- (void)didSelectActionWithType:(ActivityEventsType)type index:(NSInteger)index;
//
//@end

@interface ActivityCell : UITableViewCell

@property (nonatomic, strong) ActivityModel *activity;

//@property (nonatomic, weak) id <ActivityCellDelegate>delegate;

@end
