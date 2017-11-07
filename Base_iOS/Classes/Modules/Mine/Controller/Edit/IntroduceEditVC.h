//
//  IntroduceEditVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^IntroduceSuccess)(NSString *introduce);

@interface IntroduceEditVC : BaseViewController

@property (nonatomic, copy) IntroduceSuccess introduceSuccess;

@property (nonatomic, copy) NSString *introduce;

@end
