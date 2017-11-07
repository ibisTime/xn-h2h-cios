//
//  BillTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "BillModel.h"

@interface BillTableView : TLTableView

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
