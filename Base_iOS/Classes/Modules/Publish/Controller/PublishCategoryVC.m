//
//  PublishCategoryVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/12.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PublishCategoryVC.h"
#import "MJRefresh.h"

@interface PublishCategoryVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) TLTableView *rightTableView;

@property (nonatomic, copy) NSArray <PublishCategoryModel *>*bigPlateRoom;
@property (nonatomic, copy) NSArray <PublishCategoryModel *>*smallPlateRoom;

@property (nonatomic, strong) TLPageDataHelper *rightPageDateHelper;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation PublishCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝贝分类";
    
    [self initTableView];
    
    [self requestData];
    
    [self.leftTableView.mj_header beginRefreshing];
}

#pragma mark - Init

- (void)initTableView {
    
    self.selectIndex = 0;
    
    //leftTableView
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(90);
    }];
    
    self.leftTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    
    
    //右边
    self.rightTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.rightTableView];
    self.rightTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分类"];
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.equalTo(self.leftTableView.mas_top);
        make.bottom.equalTo(self.leftTableView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
}

#pragma mark - Data

- (void)requestData {
    
    //    状态 0 待上架 1 已上架 2 已下架
    //左侧大类
    __weak typeof(self) weakSelf = self;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"808007";
        http.parameters[@"status"] = @"1";
        http.parameters[@"type"] = @"4";
        http.parameters[@"parentCode"] = @"0";
        
        [http postWithSuccess:^(id responseObject) {
            
            weakSelf.bigPlateRoom  =  [PublishCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            //排序
            //            weakSelf.bigPlateRoom = [weakSelf.bigPlateRoom sortedArrayUsingComparator:^NSComparisonResult(PublishCategoryModel*  _Nonnull obj1, PublishCategoryModel*  _Nonnull obj2) {
            //
            //                if ([obj1.orderNo integerValue] > [obj2.orderNo integerValue]) {
            //
            //                    return NSOrderedDescending;
            //
            //                } else {
            //
            //                    return NSOrderedAscending;
            //                }
            //
            //            }];
            
            [weakSelf.leftTableView reloadData];
            [weakSelf.leftTableView.mj_header endRefreshing];
            [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            //刷新右侧
            weakSelf.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom.count > 0 ? self.bigPlateRoom[_selectIndex].code : @"xxxxxx";
            
            [weakSelf.rightTableView beginRefreshing];
            
        } failure:^(NSError *error) {
            
            [weakSelf.leftTableView.mj_header endRefreshing];
            
        }];
        
    }];
    
    
    //右侧 小版块 刷新---事件
    //parentCode  和 companyCode 在合适的时候改变
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808007";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"type"] = @"4";
    helper.parameters[@"parentCode"] = @"0";
    helper.isList = YES;
    helper.tableView = self.rightTableView;
    self.rightPageDateHelper = helper;
    [helper modelClass:[PublishCategoryModel class]];
    
    //
    [self.rightTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.smallPlateRoom = objs;
            [weakSelf.rightTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.leftTableView]) {
        return self.bigPlateRoom.count;
        
    } else {
        
        return self.smallPlateRoom.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWForumGeneraCellId"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWForumGeneraCellId"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
            
        }
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIColor whiteColor] convertToImage]];
        //        if (indexPath.row == 9) {
        ////            cell.selected = YES;
        ////            [cell setSelected:YES animated:YES];
        //
        //        }
        
        cell.textLabel.textColor = kTextColor2;
        
        cell.textLabel.font = Font(13.0);
        
        cell.textLabel.text = self.bigPlateRoom[indexPath.row].name;
        
        UIView *selectBgView = [[UIView alloc] initWithFrame:cell.frame];
        
        selectBgView.backgroundColor = kWhiteColor;
        
        cell.selectedBackgroundView = selectBgView;
        
        cell.textLabel.highlightedTextColor = kTextColor;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kAppCustomMainColor;
        [selectBgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(2.5);
            make.centerY.mas_equalTo(0);
        }];
        
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWSubClassCellId"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWSubClassCellId"];
            
        }
        
        PublishCategoryModel *small = self.smallPlateRoom[indexPath.row];
        
        //        [cell.subClassImageView sd_setImageWithURL:[NSURL URLWithString:[small.pic convertImageUrl]] placeholderImage:nil];
        cell.textLabel.text = small.name;
        cell.textLabel.font = Font(13.0);

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(@(kLineHeight));
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //right
    if ([tableView isEqual:self.rightTableView]) {
        
        PublishCategoryModel *category = self.smallPlateRoom[indexPath.row];
        
        if (_categoryBlock) {
            
            _categoryBlock(category);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    //left
    
    self.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom[indexPath.row].code;
    [self.rightTableView beginRefreshing];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        
        return 40;
        
    }
    
    return 40;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
