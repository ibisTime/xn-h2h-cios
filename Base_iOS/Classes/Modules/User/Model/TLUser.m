//
//  TLUser.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUser.h"
#import "TLUserExt.h"
#import "UICKeyChainStore.h"
#import "UserDefaultsUtil.h"
#import "CurrencyModel.h"
#import "ChatManager.h"
#import "IMAHost+HostAPIs.h"
#import "IMAHost.h"
#import "TabbarViewController.h"

//#define USER_ID_KEY @"user_id_key_csw"
#define TOKEN_ID_KEY @"token_id_key_csw"
#define USER_INFO_DICT_KEY @"user_info_dict_key_csw"

NSString *const kUserLoginNotification = @"kUserLoginNotification_csw";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification_csw";
NSString *const kUserInfoChange = @"kUserInfoChange_csw";

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
        
    });
    
    return user;

}

#pragma mark- 调用keyChainStore
//- (void)keyChainStore {
//
//    UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:@"zh_bound_id"];
//    
//    //存值
//    [keyChainStore setString:@"" forKey:@""];
//    //取值
//    [keyChainStore stringForKey:@""];
//
//}

- (void)initUserData {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    self.token = token;
    
    //--//
    [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];

}


- (void)saveToken:(NSString *)token {

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (token) {
        
        return YES;
    } else {
    
    
        return NO;
    }

}

- (void)reLogin {
    
    self.userName = [UserDefaultsUtil getUserDefaultName];
    
    self.userPassward = [UserDefaultsUtil getUserDefaultPassword];
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.userName;
    http.parameters[@"loginPwd"] = self.userPassward;
    http.parameters[@"kind"] = APP_KIND;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *token = responseObject[@"data"][@"token"];
        
        self.token = token;
        
        [[TLUser user] saveToken:token];
        
        //异步跟新用户信息
        [[TLUser user] updateUserInfo];
        
        [self requestAccountNumber];
        
        //获取腾讯云IM签名、账号并登录
        [[ChatManager sharedManager] getTencentSign];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 账户
- (void)requestAccountNumber {
    
    BaseWeakSelf;
    
    //获取人民币和积分账户
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"JF"]) {
                
                weakSelf.jfAccountNumber = obj.accountNumber;
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                weakSelf.rmbAccountNumber = obj.accountNumber;
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)loginOut {

    self.userId = nil;
    self.token = nil;
//    self.rmbNum = nil;
//    self.jfNum = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.userExt = nil;
    self.tradepwdFlag = nil;
    self.level = nil;
    self.isWXLogin = NO;
    self.totalFansNum = nil;
    self.totalFollowNum = nil;
    self.rmbAccountNumber = nil;
    self.jfAccountNumber = nil;
    self.unReadMsgCount = 0;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_out_notification" object:nil];
}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
        
        @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (TLUserExt *)userExt {

    if (!_userExt) {
        _userExt = [[TLUserExt alloc] init];
        
    }
    return _userExt;

}

- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
//        NSLog(@"原%@--现%@",[TLUser user].userId,responseObject[@"data"][@"userId"]);
//        if (![[TLUser user].userId isEqualToString:responseObject[@"data"][@"userId"]]) {
//            
//            @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
//            
//        }
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)setUserInfoWithDict:(NSDictionary *)dict {

    self.userId = dict[@"userId"];
    
    //token用户信息没有返回，不能再此处初始化
//    self.token = dict[@"token"];
    self.mobile = dict[@"mobile"];
    self.nickname = dict[@"nickname"];
    self.realName = dict[@"realName"];
    self.idNo = dict[@"idNo"];
    self.tradepwdFlag = [NSString stringWithFormat:@"%@", dict[@"tradepwdFlag"]];
    self.level = dict[@"level"];
    self.photo = dict[@"photo"];
    self.gender = dict[@"gender"];
    self.email = dict[@"email"];
    self.introduce = dict[@"introduce"];
    self.birthday = dict[@"birthday"];
    
    self.totalFollowNum = dict[@"totalFollowNum"];
    self.totalFansNum = dict[@"totalFansNum"];
    
    self.province = dict[@"province"];
    self.city = dict[@"city"];
    self.area = dict[@"area"];

    //腾讯云-设置昵称和头像
    [IMAPlatform sharedInstance].host.icon = [self.photo convertImageUrl];

    self.referrer = [UserReferrer mj_objectWithKeyValues:dict[@"referrer"]];

    
}

- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    self.userName = userName;
    
    self.userPassward = pwd;
    
    [UserDefaultsUtil setUserDefaultName:userName];
    
    [UserDefaultsUtil setUserDefaultPassword:pwd];
    
}

- (NSString *)detailAddress {

    if (!self.userExt.province) {
        return @"未知";
    }
    return [NSString stringWithFormat:@"%@ %@ %@",self.userExt.province,self.userExt.city,self.userExt.area];

}

- (void)setUnReadMsgCount:(NSInteger)unReadMsgCount {
    
    _unReadMsgCount = unReadMsgCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDidRefresh" object:[NSString stringWithFormat:@"%ld", unReadMsgCount]];
}

@end
