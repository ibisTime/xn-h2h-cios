//
//  BaseAddressChooseView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHAddressChooseType) {

    ZHAddressChooseTypeDisplay = 0,
    ZHAddressChooseTypeChoose
    

};

@interface BaseAddressChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame ;

@property (nonatomic,copy)  void(^chooseAddress)();

@property (nonatomic,assign) ZHAddressChooseType type;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *mobileLbl;
@property (nonatomic,strong) UILabel *addressLbl;

@end
