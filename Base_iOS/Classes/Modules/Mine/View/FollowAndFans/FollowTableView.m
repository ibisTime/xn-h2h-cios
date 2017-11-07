//
//  FollowTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FollowTableView.h"
#import "FollowCell.h"

@interface FollowTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FollowTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = kBackgroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        [self adjustsContentInsets];
        
        [self registerClass:[FollowCell class] forCellReuseIdentifier:@"FollowCellId"];
    }
    
    return self;
}

#pragma mark - UITableViewSatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.follows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *followCellId = @"FollowCellId";
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:followCellId forIndexPath:indexPath];
    
    FollowAndFansModel *followModel = self.follows[indexPath.row];
    
    cell.follow = followModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_followBlock) {
        
        _followBlock(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
