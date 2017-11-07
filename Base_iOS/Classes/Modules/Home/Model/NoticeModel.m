//
//  NoticeModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

- (CGFloat)contentHeight {
    
    CGSize contentSize = [self.smsContent calculateStringSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) font:Font(15.0)];
    
    return contentSize.height;
}

@end
