//
//  ShareFunction.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
//分享类型
typedef NS_ENUM(NSInteger, ShareContentType) {
    
    ShareContentTypeText,           //分享文字
    ShareContentTypeImage,          //分享图片
    ShareContentTypeTextAndImage,   //分享图文
};

//分享对象
typedef NS_ENUM(NSInteger, ShareObjectType) {
    
    ShareObjectTypeQQ,              //QQ
    ShareObjectTypeQZone,           //QQ空间
    ShareObjectTypeWeChat,          //微信好友
    ShareObjectTypeWeChatFriends,   //朋友圈
    ShareObjectTypeWeiBo,           //微博
    ShareObjectTypeDouBan,          //豆瓣
    ShareObjectTypeTwitter,         //Twitter
    ShareObjectTypeFacebook,        //Facebook
};

typedef void(^ShareResultBlock)(id data, NSError *error);
@interface ShareFunction : NSObject

@property (nonatomic, strong) NSString *shareTitle;

@property (nonatomic, strong) NSString *shareURL;

@property (nonatomic, strong) NSString *shareImgStr;

@property (nonatomic, strong) NSString *shareDesc;

@property (nonatomic, assign) ShareContentType shareContentType;

@property (nonatomic, assign) ShareObjectType shareObjectType;

@property (nonatomic, copy) ShareResultBlock resultBlock;

- (void)startShare;

@end
