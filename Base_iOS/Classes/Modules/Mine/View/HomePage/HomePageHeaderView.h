//
//  HomePageHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomePageType) {
    
    HomePageTypeEdit = 0,       //编辑资料
    HomePageTypeFollow,         //关注
    HomePageTypeCancelFollow,   //取消关注
    HomePageTypeChat,           //私聊
};

typedef void(^HomePageHeaderEventsBlock)(HomePageType type);

@interface HomePageHeaderView : UICollectionReusableView

@property (nonatomic, strong) TLUser *user;
//背景
@property (nonatomic, strong) UIImageView *bgIV;
//头像
@property (nonatomic, strong) UIImageView *userPhoto;
//名称
@property (nonatomic, strong) UILabel *nameLbl;
//关注
@property (nonatomic, strong) UIButton *followBtn;
//已发布数量
@property (nonatomic, assign) NSInteger publishNum;
//在线数量
@property (nonatomic, assign) NSInteger onNum;
//是否被关注
@property (nonatomic, assign) BOOL isFollow;

@property (nonatomic, copy) HomePageHeaderEventsBlock headerBlock;

@end
