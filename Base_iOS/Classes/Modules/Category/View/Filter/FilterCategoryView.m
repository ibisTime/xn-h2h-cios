//
//  FilterCategoryView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterCategoryView.h"
#import "PublishCategoryModel.h"
#import "MJRefresh.h"

@interface FilterCategoryView ()<UITableViewDataSource,UITableViewDelegate>
//大类
@property (nonatomic, strong) TLTableView *leftTableView;
//小类
@property (nonatomic, strong) TLTableView *rightTableView;

@property (nonatomic, strong) NSMutableArray <PublishCategoryModel *>*bigPlateRoom;
@property (nonatomic, strong) NSMutableArray <PublishCategoryModel *>*smallPlateRoom;

@property (nonatomic, strong) TLPageDataHelper *rightPageDateHelper;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) PublishCategoryModel *category;

@property (nonatomic, assign) BOOL isCategory;

@end

@implementation FilterCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.bigPlateRoom = [NSMutableArray array];

        //
        [self initTableView];

        [self requestData];
        
    }
    
    return self;
}

#pragma mark - Init

- (void)initTableView {
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];
    
    self.selectIndex = 0;
    
    //leftTableView
    self.leftTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
    
    self.leftTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];

    [self addSubview:self.leftTableView];

    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@(360));
        make.width.mas_equalTo(90);
    }];
    
    //右边
    self.rightTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
    
    self.rightTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分类"];
    
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.rightTableView];

    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@(360));
        make.right.equalTo(self.mas_right);
    }];
    
}

#pragma mark - Data

- (void)requestData {
    
    //    状态 0 待上架 1 已上架 2 已下架
    //左侧大类
    __weak typeof(self) weakSelf = self;
    TLNetworking *http = [TLNetworking new];
    http.code = @"808007";
    http.parameters[@"status"] = @"1";
    http.parameters[@"type"] = @"4";
    http.parameters[@"parentCode"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        PublishCategoryModel *category = [PublishCategoryModel new];
        
        category.name = @"全部";
        category.pic = @"1";
        category.status = @"1";
        
        [weakSelf.bigPlateRoom addObject:category];
        
        NSArray *arr = [PublishCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [weakSelf.bigPlateRoom addObjectsFromArray:arr];
        
        [weakSelf.leftTableView reloadData];
        [weakSelf.leftTableView.mj_header endRefreshing];
        [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        //刷新右侧
        
        weakSelf.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom.count > 0 ? self.bigPlateRoom[_selectIndex].code : @"xxxxxx";
        
        [weakSelf.rightTableView beginRefreshing];
        
    } failure:^(NSError *error) {
        
        [weakSelf.leftTableView.mj_header endRefreshing];
        
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
            

            if (objs.count > 0) {

                weakSelf.rightTableView.tableFooterView = nil;

                weakSelf.smallPlateRoom = [NSMutableArray array];

                PublishCategoryModel *category = [PublishCategoryModel new];

                category.name = @"全部";
                category.pic = @"1";
                category.status = @"1";

                [weakSelf.smallPlateRoom addObject:category];

                [weakSelf.smallPlateRoom addObjectsFromArray:objs.copy];

                [weakSelf.rightTableView reloadData_tl];

            } else {

                weakSelf.smallPlateRoom = objs;
                
                [weakSelf.rightTableView reloadData_tl];

                weakSelf.rightTableView.tableFooterView = [TLPlaceholderView placeholderViewWithText:@"暂无分类"];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
}

#pragma mark - Events
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
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
        
        if (self.selectIndex != 0) {
            
            PublishCategoryModel *small = self.smallPlateRoom[indexPath.row];
            
            cell.textLabel.text = small.name;
            cell.textLabel.font = Font(13.0);
            cell.textLabel.textColor = kTextColor2;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       
        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FilterManager *filter = [FilterManager manager];
    
    //right
    if ([tableView isEqual:self.rightTableView]) {
        
        if (indexPath.row == 0) {
            
            PublishCategoryModel *category = self.bigPlateRoom[self.selectIndex];
            
            filter.category = category;
            
            filter.isCategory = YES;
            
        } else {
            
            filter.category = self.smallPlateRoom[indexPath.row];
            
            filter.isCategory = NO;

        }
        
        if (_done) {
            
            _done();
        };
        
    }
    //left
    if (indexPath.row == 0) {
        
        PublishCategoryModel *category = self.bigPlateRoom[self.selectIndex];
        
        filter.category = category;
        
        filter.isCategory = YES;
        
        if (_done) {
            
            _done();
        };
        
    } else {
        
        self.rightPageDateHelper.parameters[@"parentCode"] = self.bigPlateRoom[indexPath.row].code;
        [self.rightTableView beginRefreshing];
    }

    self.selectIndex = indexPath.row;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftTableView]) {
        
        return 40;
    }
    
    return 40;
    
}

@end
