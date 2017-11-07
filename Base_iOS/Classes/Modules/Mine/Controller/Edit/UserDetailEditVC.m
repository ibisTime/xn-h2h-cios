//
//  UserDetailEditVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UserDetailEditVC.h"

#import "TLTextView.h"
#import "UserEditCell.h"

#import "UserEditModel.h"
#import "TLImagePicker.h"
#import "TLDatePicker.h"

#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"

#import "IMAHost+HostAPIs.h"
#import "IMAHost.h"

#import "EditVC.h"
#import "IntroduceEditVC.h"

@interface UserDetailEditVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *models;

@property (nonatomic, strong) TLImagePicker *imgPicker;
@property (nonatomic, strong) TLTableView *editTableView;
//@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) TLDatePicker *datePicker;
@property (nonatomic, strong) TLTextView *textView;

@end

@implementation UserDetailEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel labelWithTitle:@"个人资料"];
    
    [self initTableView];
    
    [self initEditModel];
    
    [self setPickFinish];
    
}

#pragma mark - Init
- (void)initTableView {
    
    TLTableView *editTableView = [TLTableView groupTableViewWithFrame:CGRectZero delegate:self dataSource:self];
    
    editTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:editTableView];
    self.editTableView = editTableView;
    
    [editTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
//    editTableView.tableFooterView = self.textView;
}

- (void)initEditModel {
    
    UserEditModel *photoModel = [UserEditModel new];
    photoModel.title = @"头像";
    if ([TLUser user].photo) {
        
        photoModel.url = [[TLUser user].photo convertImageUrl];
        
    } else {
        
        photoModel.url = @"没有头像";
    }
    
    //昵称
    UserEditModel *nickNameModel = [UserEditModel new];
    nickNameModel.title = @"昵称";
    nickNameModel.content = [TLUser user].nickname;
    
    //生日
    UserEditModel *birthdayModel = [UserEditModel new];
    birthdayModel.title = @"生日";
    birthdayModel.content =  [TLUser user].birthday ? [TLUser user].birthday : @"请选择生日";
    
    //性别
    UserEditModel *sexModel = [UserEditModel new];
    sexModel.title = @"性别";
    if ([TLUser user].gender) {
        
        sexModel.content = [[TLUser user].gender isEqualToString:@"1"] ? @"男" : @"女";
        
    } else {
        
        sexModel.content = @"请选择性别";
    }
    
    //个人简介
    UserEditModel *introduceModel = [UserEditModel new];
    introduceModel.title = @"个人简介";
    introduceModel.content = [TLUser user].introduce ? [TLUser user].introduce.length > 10 ? [[TLUser user].introduce substringToIndex:10]: [TLUser user].introduce: @"介绍一下自己";
    
    self.models = @[@[photoModel,nickNameModel,birthdayModel,sexModel, introduceModel]];
}

- (void)setPickFinish {
    
    BaseWeakSelf;
    
    [self.imgPicker setPickFinish:^(NSDictionary * info) {
        
        //图片上传
        TLNetworking *getUploadToken = [TLNetworking new];
        getUploadToken.showView = weakSelf.view;
        getUploadToken.code = IMG_UPLOAD_CODE;
        getUploadToken.parameters[@"token"] = [TLUser user].token;
        [getUploadToken postWithSuccess:^(id responseObject) {
            
            [TLProgressHUD showWithStatus:@""];
            //
            
            QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
                
            }]];
            
            NSString *token = responseObject[@"data"][@"uploadToken"];
            
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
            
            [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                [TLProgressHUD dismiss];
                
                if (!info.error) {
                    
                    //设置头像
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = USER_CHANGE_USER_PHOTO;
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"修改头像成功"];
                        [TLUser user].photo = key;
                        
                        NSArray <UserEditModel *>*arr = weakSelf.models[0];
                        
                        arr[0].img = image;
                        [weakSelf.editTableView reloadData];
                        
                        //
                        [[TLUser user] updateUserInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
                        
                        //设置头像
                        [[IMAHost alloc] asyncSetHeadIconURL:key succ:^{
                            
                        } fail:^(int code, NSString *msg) {
                            
                        }];
                        
                        [IMAPlatform sharedInstance].host.icon = key;
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                } else {
                    
                    [TLAlert alertWithError:@"图片上传失败"];
                }
                
            } option:nil];
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

#pragma mark - datePicker
- (void)dateChange:(UIDatePicker *)datePicker {
    
    
    
}

#pragma mark - 资料保存
//- (void)save {
//
//    NSArray <UserEditModel *>*arr = self.models[0];
//
//    NSString *birthdayStr = arr[2].content;
//    NSString *sexStr = arr[3].content;
//    NSString *emailStr = arr[4].content;

    
    
//    if ([birthdayStr isEqualToString:@"请选择生日"]) {
//        
//        [TLAlert alertWithInfo:@"请填写生日"];
//        return;
//    }
//    
//    if ([sexStr isEqualToString:@"请选则性别"]) {
//        
//        [TLAlert alertWithInfo:@"请选择性别"];
//        return;
//    }
//    
//    if ([emailStr isEqualToString:@"请填写邮箱"]) {
//        
//        [TLAlert alertWithInfo:@"请填写邮箱"];
//        return;
//    }
//    
//    if (![self.textView.text valid]) {
//        
//        [TLAlert alertWithInfo:@"请填写自我介绍"];
//        return;
//    }
    
    //昵称修改上传不在此处
    
    //用户扩展信息修改
//    TLNetworking *userExtHttp = [TLNetworking new];
//    userExtHttp.showView = self.view;
//    userExtHttp.code = USER_CHANGE_USER_INFO;
//    userExtHttp.parameters[@"userId"] = [TLUser user].userId;
//    userExtHttp.parameters[@"token"] = [TLUser user].token;
//
//    //--//
//    if (sexStr) {
//        userExtHttp.parameters[@"gender"] = [sexStr isEqualToString:@"男"] ? @"1" : @"0";
//
//    }
//
//    userExtHttp.parameters[@"birthday"] = birthdayStr;
//
//    userExtHttp.parameters[@"email"] = emailStr;
//
//    if (self.textView.text.length > 0) {
//
//        userExtHttp.parameters[@"introduce"] = self.textView.text;
//
//    }
//
//    [userExtHttp postWithSuccess:^(id responseObject) {
//
//        [TLAlert alertWithSucces:@"保存成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//
//        TLUser *user = [TLUser user];
//
//        user.userExt.birthday = birthdayStr;
//        user.userExt.introduce = self.textView.text;
//        user.userExt.email = emailStr;
//        user.userExt.gender = [sexStr isEqualToString:@"男"] ? @"1" : @"0";
//
//        [[TLUser user] updateUserInfo];
//        //发出用户信息变更通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
//
//    } failure:^(NSError *error) {
//
//
//    }];

    
//}

- (TLTextView *)textView {
    
    if (!_textView) {
        
        _textView = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        _textView.font = FONT(15);
        _textView.textColor = [UIColor textColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 3, 0, 6);
        _textView.placholder = @"个性签名~~";
        _textView.placeholderLbl.textColor = [UIColor textColor2];
    }
    return _textView;
    
}

- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        __weak typeof(self) weakSelf = self;
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *loaclDate = [NSString getLocalDate];
        
        NSString *loaclStr = [NSString stringFromDate:loaclDate formatter:@"yyyy-MM-dd"];
        
        NSString *monthStr = [NSString stringFromDate:loaclDate formatter:@"MM-dd"];
        
        NSString *yearStr = [loaclStr substringToIndex:4];
        
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%@", yearStr.integerValue - 100, monthStr];
        
        NSDate *minDate = [NSString dateFromString:dateStr formatter:@"yyyy-MM-dd"];
        
        _datePicker.datePicker.minimumDate = minDate;
        _datePicker.datePicker.maximumDate = loaclDate;
        
        [_datePicker.datePicker setDate:loaclDate animated:YES];
        
        [_datePicker setConfirmAction:^(NSDate *date) {
            
            NSArray <UserEditModel *>*arr = weakSelf.models[0];
            
            UserEditModel *editModel = arr[2];
            
            editModel.content =  [NSString stringFromDate:date formatter:@"yyyy-MM-dd"];
            
            [weakSelf changeBirthday];
            
        }];
    }
    return _datePicker;
    
}

- (TLImagePicker *)imgPicker {
    
    if (!_imgPicker) {
        
        _imgPicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imgPicker.allowsEditing = YES;
        
    }
    return _imgPicker;
    
}

#pragma mark - Data
- (void)changeBirthday {
    
    NSArray <UserEditModel *>*arr = self.models[0];

    NSString *birthdayStr = arr[2].content;

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805096";
    http.showView = self.view;
    
    http.parameters[@"birthday"] = birthdayStr;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.editTableView reloadData];

        [TLAlert alertWithSucces:@"生日修改成功"];
    
        [TLUser user].birthday = birthdayStr;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)changeGender {
    
    NSArray <UserEditModel *>*arr = self.models[0];
    
    NSString *sexStr = arr[3].content;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805097";
    http.showView = self.view;
    
    http.parameters[@"gender"] = [sexStr isEqualToString:@"男"] ? @"1" : @"0";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.editTableView reloadData];
        
        [TLAlert alertWithSucces:@"修改成功"];
        
        [TLUser user].gender = [sexStr isEqualToString:@"男"] ? @"1" : @"0";;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.models[section];
    
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserEditCellId"];
    if (!cell) {
        
        cell = [[UserEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserEditCellId"];
        
    }
    NSArray <UserEditModel *>*arr = self.models[indexPath.section];
    
    UserEditModel *model = arr[indexPath.row];
    
    cell.titleLbl.text = model.title;
    
    if (model.url || model.img) {
        
        //优先URl
        //img
        //imageName
        if (model.img) {
            
            cell.userPhoto.image = model.img;
            
        } else if (model.url) {
            
            [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:USER_PLACEHOLDER_SMALL];
        }
        
    } else {
        
        cell.contentLbl.text = model.content;
    }
    
    cell.lineView.hidden = indexPath.row == arr.count - 1? YES: NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserEditCell *cell = (UserEditCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSArray <UserEditModel *>*arr = self.models[indexPath.section];
    
    UserEditModel *model = arr[indexPath.row];
    
    if (model.url) { //选择图片
        
        [self.imgPicker picker];
        
    } else { //其它编辑
        
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 1: {//昵称
                    
                    EditVC *editVC = [[EditVC alloc] init];
                    editVC.title = @"填写昵称";
                    editVC.editModel = model;
                    editVC.type = UserEditTypeNickName;
                    editVC.nickName = cell.contentLbl.text;
                    
                    [editVC setDone:^{
                        
                        [tableView reloadData];
                    }];
                    
                    [self.navigationController pushViewController:editVC animated:YES];
                    
                }break;
                case 2: {//生日
                    
                    [self.datePicker show];
                    
                }break;
                case 3: {//性别
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择您的性别" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        model.content = @"男";
                        
                        [self changeGender];
                        
                    }]];
                    
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        model.content = @"女";
                        
//                        [self.editTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

                        [self changeGender];
                        
                    }]];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }break;
                    
                case 4:
                {
                    IntroduceEditVC *editVC = [IntroduceEditVC new];
                    
                    editVC.introduce = [TLUser user].introduce;
                    
                    editVC.introduceSuccess = ^(NSString *introduce) {
                        
                        model.content = introduce ? introduce.length > 10 ? [introduce substringToIndex:10]: introduce: @"介绍一下自己";
                        
                        [tableView reloadData];

                    };
                    
                    [self.navigationController pushViewController:editVC animated:YES];
                    
                }break;
                    
            }
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return indexPath.row == 0 ? 80 : 45;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
