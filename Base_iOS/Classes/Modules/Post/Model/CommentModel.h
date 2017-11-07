//
//  CommentModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

//构造数据
//@property (nonatomic, copy) NSString *commentUserId;
//@property (nonatomic, copy) NSString *commentUserNickname;
//@property (nonatomic, copy) NSString *commentContent;
//
////互访数据
//@property (nonatomic, copy) NSString *parentCommentUserId;
//@property (nonatomic, copy) NSString *parentCommentUserNickname;
//@property (nonatomic, copy) NSString *commentDatetime;



//原生数据
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status;
//评论时间
@property (nonatomic, copy) NSString *commentDatetime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commenter; //userId

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *entityCode;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSNumber *score;
//@property (nonatomic, strong) NSMutableDictionary *parentComment;


//- (instancetype)initWithCommentUserId:(NSString *)commentUserId
//                  commentUserNickname:(NSString *)commentUserNickname
//                       commentContent:(NSString *)commentContent
//                  parentCommentUserId:(NSString *)parentCommentUserId
//            parentCommentUserNickname:(NSString *)parentCommentUserNickname commentDatetime:(NSString *)commentDatetime;

@end
