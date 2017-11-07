//
//  BillModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BillModel : BaseModel

//@property (nonatomic,copy) NSString *accountNumber;
//@property (nonatomic,copy) NSString *bizNote; //备注
//
//@property (nonatomic,copy) NSString *bizType;
//@property (nonatomic,copy) NSString *channelType;
//@property (nonatomic,copy) NSString *code;
//@property (nonatomic,copy) NSString *createDatetime;
//@property (nonatomic,copy) NSString *postAmount;
//@property (nonatomic,copy) NSString *preAmount;
//@property (nonatomic,copy) NSString *realName;
//@property (nonatomic, copy) NSString *currency;
//@property (nonatomic, strong) NSNumber *fee;  //手续费
//
//@property (nonatomic,copy) NSString *status;
//@property (nonatomic,copy) NSString *systemCode;
//@property (nonatomic,strong) NSNumber *transAmount;
//
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *workDate; //工作日期
//
//@property (nonatomic, strong) NSNumber *payAmount1;
//@property (nonatomic, strong) NSNumber *payAmount2;
//@property (nonatomic, strong) NSNumber *payAmount3;
//@property (nonatomic, assign) NSInteger payType;
//@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger preAmount;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, copy) NSString *channelType;

@property (nonatomic, copy) NSString *refNo;

@property (nonatomic, copy) NSString *bizNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger postAmount;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSNumber *transAmount;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *bizType;

@property (nonatomic, copy) NSString *workDate;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *status;

- (NSString *)getBizName;
- (CGFloat)dHeightValue;

@end
