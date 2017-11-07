//
//  SyetemNoticeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SyetemNoticeVC.h"
#import "NoticeCell.h"

#import "NoticeModel.h"

#import "NoticeDetailVC.h"

@interface SyetemNoticeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSMutableArray <NoticeModel *>*notices;

@end

@implementation SyetemNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"系统消息"];
    
    [self initTableView];
    
    [self getNotice];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    self.tableView.backgroundColor = kBackgroundColor;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)getNotice {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    helper.showView = self.view;
    
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[NoticeModel class]];
    
    //资讯数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        weakSelf.notices = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
    
}

#pragma mark- datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.notices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *noticeCellID = @"NoticeCell";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellID];
    if (!cell) {
        
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noticeCellID];
    }
    
    NoticeModel *notice = self.notices[indexPath.section];
    
    cell.notice = notice;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark- tableView  --- delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoticeDetailVC *detailVC = [NoticeDetailVC new];
    
    detailVC.notice = self.notices[indexPath.section];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    return self.notices[indexPath.section].cellHeight;
    
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    return view;
}



@end
