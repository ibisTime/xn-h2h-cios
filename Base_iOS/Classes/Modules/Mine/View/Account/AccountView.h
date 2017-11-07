//
//  AccountView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfoModel.h"

typedef NS_ENUM(NSUInteger, AccountType) {
    AccountTypeRecharge = 0,    //充值
    AccountTypeWithdrawals,     //提现
    AccountTypeRMBFlow,         //RMB流水
    
};

@protocol AccountDelegate <NSObject>

- (void)didSelectedWithType:(AccountType)type idx:(NSInteger)idx;

@end

@interface AccountView : UIView

@property (nonatomic, weak) id<AccountDelegate> delegate;

@property (nonatomic, assign) AccountType taskType;

@property (nonatomic, copy) NSString *rmbText;

@property (nonatomic, strong) AccountInfoModel *accountModel;

@end
