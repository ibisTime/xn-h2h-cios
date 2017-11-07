//
//  CircleTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CircleTableView.h"

#import "CircleCell.h"

@interface CircleTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CircleTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[CircleCell class] forCellReuseIdentifier:@"CircleCellId"];

    }
    return self;
}

#pragma mark - UITableViewSatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.circleList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *circleCellId = @"CircleCellId";
    CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:circleCellId forIndexPath:indexPath];
    
    GoodModel *goodModel = self.circleList[indexPath.row];
    
    cell.goodModel = goodModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.photoImageView.tag = 2000 + indexPath.row;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHomePage:)];
    
    [cell.photoImageView addGestureRecognizer:tapGR];
    
    return cell;
}

- (void)clickHomePage:(UITapGestureRecognizer *)tapGR {
    
    if (_circleBlock) {
        
        _circleBlock(tapGR.view.tag - 2000, CircleEventsTypeHomePage);
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_circleBlock) {
        
        _circleBlock(indexPath.row, CircleEventsTypeDetail);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodModel *goodModel = self.circleList[indexPath.row];
    
    return goodModel.cellHeight;
//    return 253.5;
    
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
