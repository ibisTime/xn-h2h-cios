//
//  SendCommentVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CommentModel.h"


typedef NS_ENUM(NSUInteger, SendCommentActionType) {
    
    SendCommentActionTypeComment = 0,
    
    SendCommentActionTypeLeaveMessage = 1
    
};

@interface SendCommentVC : TLBaseVC

@property (nonatomic, assign) SendCommentActionType type;
//发送对象的Code
@property (nonatomic, copy) NSString *toObjCode;
//对帖子发就没有
@property (nonatomic, copy) NSString *toObjNickName;
//标题
@property (nonatomic, copy) NSString *titleStr;
//产品code
@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, copy) void(^commentSuccess)(CommentModel *commentModel);

@end
