//
//  ZHPayFuncModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/25.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZHPayType) {

    ZHPayTypeBalance = 0,   //余额
    ZHPayTypeWeChat,
    ZHPayTypeIntegral,  //积分
    ZHPayTypeCouponPay, //优惠券
};

@interface ZHPayFuncModel : NSObject

@property (nonatomic,copy) NSString *payImgName;
@property (nonatomic,copy) NSString *payName;
@property (nonatomic,assign) ZHPayType payType;
@property (nonatomic,assign) BOOL isSelected;

@end
