//
//  ZHBankCardListVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardListVC.h"
#import "ZHBankCardAddVC.h"
#import "ZHBankCardCell.h"
#import "TLPageDataHelper.h"
#import "ZHBankCard.h"

@interface ZHBankCardListVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *bankCardTV;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHBankCardListVC

- (instancetype)init {

    if (self = [super init]) {
        self.isFirst = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.bankCardTV beginRefreshing];
        self.isFirst = NO;
    }

}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"我的银行卡";

    TLTableView *bankCardTV = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                       delegate:self
                                                     dataSource:self];
    self.bankCardTV = bankCardTV;
    bankCardTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bankCardTV];
    bankCardTV.rowHeight = 140;
    
    bankCardTV.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无银行卡"];
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = bankCardTV;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"userId"] = [TLUser user].userId;
    [pageDataHelper modelClass:[ZHBankCard class]];
    [bankCardTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            
            //限定绑一张
            if (objs.count >= 1) {
                
                self.navigationItem.rightBarButtonItem = nil;
                
            } else {
            
                [UIBarButtonItem addRightItemWithTitle:@"添加" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(add)];
                
            }
            
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [bankCardTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}

- (void)add {

    BaseWeakSelf;
    
    ZHBankCardAddVC *bankCardAddVC= [[ZHBankCardAddVC alloc] init];
    
    bankCardAddVC.title = @"添加银行卡";
    bankCardAddVC.addSuccess = ^(ZHBankCard *card){
    
        [weakSelf.bankCardTV beginRefreshing];
        
    };
    [self.navigationController pushViewController:bankCardAddVC animated:YES];

}


//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                      title:@"删除"
//                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//                                                                        [self deleteBankCardWithTableView:tableView index:indexPath];
//
//                                                                    }];
//
//    return @[action];
//
//}

//

//
//- (void)deleteBankCardWithTableView:(UITableView *)tv index:(NSIndexPath *)indexPath {
//
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"802011";
//    http.parameters[@"token"] = [TLUser user].token;
//    http.parameters[@"code"] = self.banks[indexPath.row].code;
//    http.parameters[@"userId"] = [TLUser user].userId;
//
//    [http postWithSuccess:^(id responseObject) {
//
//        [TLUser user].bankcardFlag = @"0";
//        //
//        [self.bankCardTV beginRefreshing];
//
//    } failure:^(NSError *error) {
//
//
//    }];
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.banks.count;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BaseWeakSelf;
    
    ZHBankCardAddVC *displayAddVC = [[ZHBankCardAddVC alloc] init];
    
    displayAddVC.title = @"修改银行卡";
    if (self.banks.count > 0) {
        
        displayAddVC.bankCard = self.banks[indexPath.row];
    }
    displayAddVC.addSuccess = ^(ZHBankCard *card){
        
        [weakSelf.bankCardTV beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:displayAddVC animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *bankCardCellId = @"bankCardCellId";
    ZHBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardCellId];
    if (!cell) {
        cell = [[ZHBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCardCellId];
    }
    cell.bankCard = self.banks[indexPath.row];
    return cell;

}


@end
