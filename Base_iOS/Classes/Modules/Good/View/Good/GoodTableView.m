//
//  GoodTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodTableView.h"
#import "GoodListCell.h"

@interface GoodTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GoodTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor = kBackgroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        [self adjustsContentInsets];
        
        [self registerClass:[GoodListCell class] forCellReuseIdentifier:@"GoodCellId"];
    }
    
//    return [GoodTableView tableViewWithFrame:frame delegate:self dataSource:self];
    return self;
}

#pragma mark - UITableViewSatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.goods.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GoodCellId = @"GoodCellId";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodCellId forIndexPath:indexPath];
    
    GoodModel *goodModel = self.goods[indexPath.row];
    
    cell.goodModel = goodModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_goodBlock) {
        
        _goodBlock(indexPath);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

@end
