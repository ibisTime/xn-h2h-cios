//
//  MyPublishTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MyPublishTableView.h"
#import "GoodListCell.h"
#import "PublishFooterView.h"

@interface MyPublishTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyPublishTableView

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
        
        [self registerClass:[GoodListCell class] forCellReuseIdentifier:@"PublishCellId"];
    }
    
    return self;
}

#pragma mark - UITableViewSatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *publishCellId = @"PublishCellId";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:publishCellId forIndexPath:indexPath];
    
    GoodModel *goodModel = self.goods[indexPath.section];
    
    cell.goodModel = goodModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodModel *good = self.goods[indexPath.section];
    
    if (_publishBlock) {
        
        _publishBlock(PublishTypeClickCell, good, indexPath.section);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0.1: 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    BaseWeakSelf;
    
    static NSString * footerId = @"PublishFooterViewId";
    
    PublishFooterView *footerView = [[PublishFooterView alloc] initWithReuseIdentifier:footerId];
    
    GoodModel *good = self.goods[section];
    
    footerView.publishBlock = ^(PublishEventsType type) {
        
        [weakSelf publishEventsWithType:type good:good section:section];

    } ;
    
    footerView.good = self.goods[section];

    return footerView;
}

#pragma mark - Events
- (void)publishEventsWithType:(PublishEventsType)type good:(GoodModel *)good section:(NSInteger)section {
    
    switch (type) {
        case PublishEventsTypeEdit:
        {
            if ([good.status isEqualToString:@"3"]) {
                
                [TLAlert alertWithInfo:@"请先下架产品后再进行编辑"];
                
            } else if ([good.status isEqualToString:@"5"]) {
                
                if (_publishBlock) {
                    
                    _publishBlock(PublishTypeEdit, good, section);
                }
            }
            
        }break;
            
        case PublishEventsTypeOff:
        {
            if (_publishBlock) {
                
                _publishBlock(PublishTypeOff, good, section);
            }
            
        }break;
            
        case PublishEventsTypeOn:
        {
            if (_publishBlock) {
                
                _publishBlock(PublishTypeOn, good, section);
            }
            
        }break;
            
        case PublishEventsTypeDelete:
        {
            if (_publishBlock) {
                
                _publishBlock(PublishTypeDelete, good, section);
            }
        }break;
            
        default:
            break;
    }

}

@end
