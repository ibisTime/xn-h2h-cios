//
//  SelectPhotoUtil.h
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/9.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock)(UIImage *image);


@class BaseViewController;

@interface SelectPhotoUtil : NSObject 


+ (instancetype)shareInstance;

- (void)selectImageViewWithViewController:(BaseViewController*)viewController success:(SuccessBlock)success;



@end
