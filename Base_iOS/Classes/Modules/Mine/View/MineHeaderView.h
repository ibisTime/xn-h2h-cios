//
//  MineHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MineHeaderSeletedType) {
    MineHeaderSeletedTypeDefault = 0,   //用户资料
    MineHeaderSeletedTypeSelectPhoto,   //拍照
    MineHeaderSeletedTypeAccount,       //人民币账户
    MineHeaderSeletedTypeIntregalFlow,  //积分流水
    MineHeaderSeletedTypeFoucsAndFans,  //关注和粉丝
    MineHeaderSeletedTypeSetting,       //设置
    
};

@protocol MineHeaderSeletedDelegate <NSObject>

- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx;

@end

@interface MineHeaderView : UIView

@property (nonatomic, strong) UIImageView *userPhoto;

@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, weak) id<MineHeaderSeletedDelegate> delegate;

//余额
@property (nonatomic, strong) NSString *rmbNum;
//积分
@property (nonatomic, copy) NSString *jfNum;
//关注
@property (nonatomic, copy) NSString *foucsNum;
//粉丝
@property (nonatomic, copy) NSString *fansNum;

@property (nonatomic, copy) NSArray <NSNumber *>*numberArray;

- (void)reset;

@end
