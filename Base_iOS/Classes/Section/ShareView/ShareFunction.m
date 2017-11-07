//
//  ShareFunction.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ShareFunction.h"
#import "UMSocialCore/UMSocialCore.h"

@interface ShareFunction ()

@property (nonatomic, assign) UMSocialPlatformType platformType;

@property (nonatomic, strong) UMSocialMessageObject *messageObject;

@end

@implementation ShareFunction

- (void)startShare {

    //与友盟的平台对接
    [self createPlatformType];
    //创建分享对象
    [self createMessageObject];
    //调用分享接口
    [self callShareInterface];
}

- (void)createPlatformType {

    switch (_shareObjectType) {
        case ShareObjectTypeQQ:
            
            _platformType = UMSocialPlatformType_QQ;
            
            break;
            
        case ShareObjectTypeQZone:
            
            _platformType = UMSocialPlatformType_Qzone;
            break;
            
        case ShareObjectTypeWeChat:
            
            _platformType = UMSocialPlatformType_WechatSession;
            
            break;
            
        case ShareObjectTypeWeChatFriends:
            
            _platformType = UMSocialPlatformType_WechatTimeLine;
            break;
            
        case ShareObjectTypeWeiBo:
            
            _platformType = UMSocialPlatformType_Sina;
            
            break;
            
        case ShareObjectTypeDouBan:
            
            _platformType = UMSocialPlatformType_Douban;
            break;
            
        case ShareObjectTypeTwitter:
            
            _platformType = UMSocialPlatformType_Twitter;
            
            break;
            
        case ShareObjectTypeFacebook:
            
            _platformType = UMSocialPlatformType_Facebook;
            break;
            
        default:
            break;
    }
}

- (void)createMessageObject {

    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    switch (_shareContentType) {
        case ShareContentTypeText:
            
        {
            //仅文字
            messageObject.title = _shareTitle;
            messageObject.text = _shareDesc;
            
            UMShareWebpageObject *shareObject = [[UMShareWebpageObject alloc] init];
            
            shareObject.webpageUrl = _shareURL;
            messageObject.shareObject = shareObject;
        }
            break;
            
        case ShareContentTypeImage:
            
        {
            //仅图片
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];

            [shareObject setShareImage:_shareImgStr];
            
            messageObject.shareObject = shareObject;
        }
            break;
            
        case ShareContentTypeTextAndImage:
            
        {
            //文字
            messageObject.title = _shareTitle;
            messageObject.text = _shareDesc;
            
            //图片
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            
            [shareObject setShareImage:_shareImgStr];
            
            messageObject.shareObject = shareObject;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UMShare
- (void)callShareInterface {
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:_platformType messageObject:_messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
//         UMSocialPlatformErrorType
//        if (error) {
//            
//            if (error.code == 2009) {
//                [self showErrorMsg:@"取消分享"];
//            }
//            else {
//                [self showErrorMsg:@"分享失败"];
//            }
//        }
//        else{
//            
//            [self showSuccessIndicator:@"分享成功"];
//        }
        
        _resultBlock(data, error);
    }];
}

@end
