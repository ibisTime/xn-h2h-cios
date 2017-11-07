//
//  PublishView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PublishView.h"
#import "PublishCell.h"

@interface PublishView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
//商品信息
@property (nonatomic, strong) UIView *goodView;
//
@property (nonatomic, strong) TLTableView *tableView;
//发布
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *rightTitleArr;

@end

@implementation PublishView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.rightTitleArr = @[@"选择分类", @"开个价", @""];

        //HeaderView
        [self initHeaderView];
        //
        [self initTableView];
        //发布按钮
        [self initBottomView];
    }
    
    return self;
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
    
    self.headerView.backgroundColor = kPaleGreyColor;
    //添加照片
    [self initPhotoView];
    //商品名称
    [self initGoodView];
}

- (void)initPhotoView {
    
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 107.5)];
    
    self.photoView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:self.photoView];
    
    UIButton *addPhotoBtn = [UIButton buttonWithTitle:@"添加照片" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:14.0];
    
    [addPhotoBtn addTarget:self action:@selector(clickAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    addPhotoBtn.frame = CGRectMake(0, 0, 100, 100);
    
    addPhotoBtn.centerX = self.centerX;
    //
    [addPhotoBtn setImage:kImage(@"添加照片_大") forState:UIControlStateNormal];
    
    [addPhotoBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -addPhotoBtn.imageView.width, 0, 0)];

    [addPhotoBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -addPhotoBtn.titleLabel.width)];
    
    [self.photoView addSubview:addPhotoBtn];
    
    self.addPhotoBtn = addPhotoBtn;
    
}

- (void)initGoodView {
    
    self.goodView = [[UIView alloc] initWithFrame:CGRectMake(0, self.photoView.yy + 10, kScreenWidth, 152.5)];
    
    self.goodView.backgroundColor = kWhiteColor;

    [self.headerView addSubview:self.goodView];
    //商品名称
    self.titleTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30) leftTitle:@"" titleWidth:15 placeholder:@"商品名称(限30字)"];
    
    [self.titleTF setValue:kTextColor2 forKeyPath:@"_placeholderLabel.textColor"];
    
    self.titleTF.font = Font(18);
    
    [self.goodView addSubview:self.titleTF];
    //广告语
    self.contentTV = [[TLTextView alloc] initWithFrame:CGRectMake(10, self.titleTF.yy, kScreenWidth - 20, 80)];
    
    self.contentTV.font = Font(15);
    
    self.contentTV.placholder = @"在这里写下商品的广告语吧";
    
    [self.goodView addSubview:self.contentTV];
    //
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentTV.yy, kScreenWidth, 32.5)];
    
    [self.goodView addSubview:addressView];
    //定位地址
    UIImageView *addressIV = [[UIImageView alloc] initWithImage:kImage(@"location")];
    
    addressIV.frame = CGRectMake(15, 0, 12, 15);
    
    addressIV.centerY = 32.5/2.0;
    
    [addressView addSubview:addressIV];
    
    self.addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(addressIV.xx + 6, 0, 0, 32.5) title:@"" backgroundColor:kWhiteColor];
    
    self.addressBtn.titleLabel.font = Font(15.0);
    
    [self.addressBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    
    [self.addressBtn addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    [addressView addSubview:self.addressBtn];
    
    //全新商品
    UIButton *newGoodBtn = [UIButton buttonWithTitle:@"全新商品" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:14.0];
    
    [newGoodBtn addTarget:self action:@selector(clickNewGood:) forControlEvents:UIControlEventTouchUpInside];
    
    newGoodBtn.frame = CGRectMake(kScreenWidth - 100 - 10, 0, 100, 32.5);
//
    [newGoodBtn setImage:kImage(@"发布_未选中") forState:UIControlStateNormal];

    [newGoodBtn setImage:kImage(@"发布_选中") forState:UIControlStateSelected];

    [newGoodBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [addressView addSubview:newGoodBtn];

    self.goodBtn = newGoodBtn;
    
}

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - 60) delegate:self dataSource:self];
    
    [self.tableView registerClass:[PublishCell class] forCellReuseIdentifier:@"PublishCellId"];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self addSubview:self.tableView];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - kBottomInsetHeight - 60, kScreenWidth, 60)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bottomView];
    
    UIButton *publishBtn = [UIButton buttonWithTitle:@"发布" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:5];
    
    publishBtn.frame = CGRectMake(15, 7.5, kScreenWidth - 2*15, 45);
    
    [publishBtn addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:publishBtn];
}

#pragma mark - Events

- (void)clickAddPhoto:(UIButton *)sender {
    
    if (_publishBlock) {
        
        _publishBlock(PublishTypeAddPhoto);
    }
}

- (void)selectAddress:(UIButton *)sender {
    
    if (_publishBlock) {
        
        _publishBlock(PublishTypeSelectAddress);
    }
}

- (void)clickNewGood:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)clickPublish {
    
    if (_publishBlock) {
        
        _publishBlock(PublishTypePublish);
    }
    
}

#pragma mark - UITableViewSatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *leftTitleArr = @[@"分类", @"价格", @"同步到圈子"];
    
    static NSString *publishCellID = @"PublishCellId";
    PublishCell *cell = [tableView dequeueReusableCellWithIdentifier:publishCellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.arrowHidden = indexPath.row == 0 ? NO: YES;
    
    cell.switchHidden = indexPath.row == 2 ? NO: YES;
    
    cell.sw.tag = 1300 + indexPath.row;
    
    cell.sw.on = YES;
    
    if (_good) {
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%@", [_good.price convertToSimpleRealMoney]];
        
        self.rightTitleArr = @[_good.categoryName, priceStr, @""];
        
        //是否同步到圈子
        //switch
        UISwitch *sw = (UISwitch *)[self viewWithTag:1302];
        
        sw.on = [_good.isPublish isEqualToString:@"1"] ? YES: NO;
    }
    
    cell.titleLbl.text = leftTitleArr[indexPath.row];
    
    cell.rightLabel.text = self.rightTitleArr[indexPath.row];
    
    cell.rightLabel.tag = 1200 + indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_publishBlock) {
        
        if (indexPath.row == 0) {
            
            _publishBlock(PublishTypeSelectCategory);
            
        } else if (indexPath.row == 1) {
            
            //输入价格
            
            _publishBlock(PublishTypeAddPrice);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
    
}

@end
