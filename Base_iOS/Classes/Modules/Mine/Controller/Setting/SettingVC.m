//
//  SettingVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SettingVC.h"
#import "CustomTabBar.h"
#import "SettingGroup.h"

#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "TLUserForgetPwdVC.h"
#import "ZHAddressChooseVC.h"
#import "ZHBankCardListVC.h"
#import "HTMLStrVC.h"

#import "SettingModel.h"
#import "SettingCell.h"
#import "TLImagePicker.h"
#import "TLUploadManager.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, copy) NSString *cacheStr;

@property (nonatomic, strong) TLTableView *mineTableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *portraitImageView;//头像

@property (nonatomic,strong) UILabel *phoneLbl;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@property (nonatomic, copy) NSString *isBorrowFlag;            //是否有借款
@end

@implementation SettingVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.mineTableView reloadData];
    
    [self setGroup];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"个人设置"];
    
    [self initTableView];
    
//    [self initHeaderView];
    
    [self userInfoChange];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:kUserInfoChange object:nil];
    
}

#pragma mark - Init
- (UIImageView *)portraitImageView {
    
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 50, 50)];
        _portraitImageView.layer.cornerRadius = 25;
        _portraitImageView.image = USER_PLACEHOLDER_SMALL;
        
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds = YES;
    }
    
    return _portraitImageView;
    
}


- (UILabel *)phoneLbl {
    
    if (!_phoneLbl) {
        _phoneLbl = [UILabel labelWithFrame:CGRectMake(self.portraitImageView.xx + 20, self.portraitImageView.y, kScreenWidth - self.portraitImageView.xx - 20 - 20 - 30, 25)
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:[UIFont secondFont]
                                  textColor:[UIColor zh_textColor]];
        _phoneLbl.centerY = self.portraitImageView.centerY;
    }
    return _phoneLbl;
    
}

- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 88)];
    
    self.headerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeadIcon:)];
    
    [self.headerView addGestureRecognizer:tapGR];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    [self.headerView addSubview:self.portraitImageView];
    
    [self.headerView addSubview:self.phoneLbl];
    
//    self.mineTableView.tableHeaderView = self.headerView;
}

- (void)initTableView {

    TLTableView *mineTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
    
    mineTableView.backgroundColor = kBackgroundColor;
    
    mineTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    [self.view addSubview:mineTableView];
    
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    mineTableView.rowHeight = 45;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    mineTableView.tableFooterView = footerView;
    mineTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    
    _mineTableView = mineTableView;
}

- (void)setGroup {

    BaseWeakSelf;
    //
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = @"修改手机号";
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
    
    }];
    
    //
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    //
    SettingModel *changePayPwd = [SettingModel new];
    
    changePayPwd.text = [[TLUser user].tradepwdFlag isEqualToString:@"0"] ? @"设置支付密码": @"修改支付密码";
    
    [changePayPwd setAction:^{
        
        TLPwdType pwdType = [[TLUser user].tradepwdFlag isEqualToString:@"0"] ? TLPwdTypeSetTrade: TLPwdTypeTradeReset;

        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        [self.navigationController pushViewController:pwdAboutVC animated:YES];

    }];
    
    //
    SettingModel *bankCard = [SettingModel new];
    bankCard.text = @"我的银行卡";
    [bankCard setAction:^{
        
        ZHBankCardListVC *vc = [[ZHBankCardListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    SettingModel *address = [SettingModel new];
    address.text = @"收货地址";
    [address setAction:^{
        
        ZHAddressChooseVC *chooseVC = [ZHAddressChooseVC new];
        
        
        [self
         .navigationController pushViewController:chooseVC animated:YES];
    }];
    
    SettingModel *aboutUs = [SettingModel new];
    aboutUs.text = @"关于我们";
    [aboutUs setAction:^{

        HTMLStrVC *htmlVC = [HTMLStrVC new];

        htmlVC.type = HTMLTypeAboutUs;

        [self.navigationController pushViewController:htmlVC animated:YES];
    }];
    
    self.group = [SettingGroup new];
    
    self.group.groups = @[@[changeMobile, changeLoginPwd, changePayPwd], @[bankCard, address, aboutUs]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 30, 45)];
        _loginOutBtn.backgroundColor = kAppCustomMainColor;
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
    
}

- (void)logout {

    UITabBarController *tbcController = self.tabBarController;
    
    //
    [self.navigationController popViewControllerAnimated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tbcController.selectedIndex = 0;
        
        CustomTabBar *tabBar = (CustomTabBar *)tbcController.tabBar;
        tabBar.selectedIdx = 0;
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
}

#pragma mark - Events

- (void)userInfoChange {
    
    NSString *photo = [TLUser user].photo;
    if (photo) {
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_SMALL]];
    }
    
    self.phoneLbl.text = [TLUser user].mobile;
    
}

- (void)selectHeadIcon:(UITapGestureRecognizer *)tapGR {
    
    __weak typeof(self) weakself = self;
    _imagePicker = [[TLImagePicker alloc] initWithVC:self];
    _imagePicker.allowsEditing = YES;
    _imagePicker.pickFinish = ^(NSDictionary *info){
        
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
        weakself.portraitImageView.image = [UIImage imageWithData:imgData];
        //进行上传
        TLUploadManager *manager = [TLUploadManager manager];
        [manager getTokenShowView:weakself.view succes:^(NSString *token) {
            
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
            }];
            
            QNUploadManager *manager = [[QNUploadManager alloc] initWithConfiguration:config];
            [manager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if (info.error) {
                    [TLAlert alertWithError:@"修改头像失败"];
                    NSLog(@"%@", info.error);
                    
                    return ;
                }
                
                TLNetworking *http = [TLNetworking new];
                http.showView = weakself.view;
                http.code = USER_CHANGE_USER_PHOTO;
                http.parameters[@"userId"] = [TLUser user].userId;
                http.parameters[@"photo"] = key;
                http.parameters[@"token"] = [TLUser user].token;
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:@"修改头像成功"];
                    [TLUser user].photo = key;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
            } option:nil];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
    };
    [_imagePicker picker];
}

#pragma mark - Data

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.group.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.group.items = self.group.groups[section];
    
    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = FONT(14);
        
    }
    
    self.group.items = self.group.groups[indexPath.section];

    cell.textLabel.text = self.group.items[indexPath.row].text;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.group.items = self.group.groups[indexPath.section];
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
