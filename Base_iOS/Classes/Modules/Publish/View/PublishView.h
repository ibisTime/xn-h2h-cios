//
//  PublishView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTextView.h"
#import "GoodModel.h"

typedef NS_ENUM(NSInteger, PublishType) {
    
    PublishTypeAddPhoto = 0,    //添加照片
    PublishTypeSelectCategory,  //选择分类
    PublishTypeAddPrice,        //开价
    PublishTypeSelectAddress,   //定位地址
    PublishTypePublish,         //发布
};

typedef void(^PublishBlock)(PublishType type);

@interface PublishView : UIView

//添加照片
@property (nonatomic, strong) UIView *photoView;
//商品名称
@property (nonatomic, strong) TLTextField *titleTF;
//商品描述
@property (nonatomic, strong) TLTextView *contentTV;
//全新商品
@property (nonatomic, strong) UIButton *goodBtn;
//定位地址
@property (nonatomic, strong) UIButton *addressBtn;
//
@property (nonatomic, strong) UIButton *addPhotoBtn;

@property (nonatomic, copy) PublishBlock publishBlock;

@property (nonatomic, strong) GoodModel *good;

@end
