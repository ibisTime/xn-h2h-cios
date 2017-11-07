//
//  GoodModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"
#import "CDGoodsParameterModel.h"

@protocol CurrencyProtocol <NSObject>

@optional

- (NSNumber *)RMB;
@end

@interface GoodModel : BaseModel<CurrencyProtocol>

@property (nonatomic,copy) NSString *advPic; //封面图片
@property (nonatomic, strong) NSNumber *boughtCount;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *costPrice;
@property (nonatomic,copy) NSString *location;
//商品描述
@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pic;
//由pic 转化成的 数组,eg: http://wwwa.dfdsf.dcom
@property (nonatomic,copy) NSArray *pics;
// 3=已上架 4=已卖出，5=已下架 ,6=强制下架
//商品状态
@property (nonatomic,copy) NSString *status;
//折扣
@property (nonatomic, strong) NSNumber *discount;
//运费
@property (nonatomic, strong) NSNumber *yunfei;
//数量
@property (nonatomic,strong) NSNumber *quantity;
//是否全新
@property (nonatomic, copy) NSString *isNew;
//是否收藏
@property (nonatomic, copy) NSString *isCollect;
//省
@property (nonatomic, strong) NSString *province;
//城市
@property (nonatomic, copy) NSString *city;
//地区
@property (nonatomic, copy) NSString *area;
//小类
@property (nonatomic, copy) NSString *typeName;
//大类
@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic,copy) NSString *type;

@property (nonatomic, copy) NSArray <CDGoodsParameterModel*> *productSpecsList;
//商品价格
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSNumber *originalPrice;

@property (nonatomic, strong) NSString *weight; //重量

@property (nonatomic, strong) CDGoodsParameterModel *selectedParameter;
//我发布的
@property (nonatomic, copy) NSString *isJoin;

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *isPublish;
//圈子
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickName;
//登录时间
@property (nonatomic, copy) NSString *loginLog;
//收藏
@property (nonatomic, strong) NSNumber *totalInteract;
//评论
@property (nonatomic, strong) NSNumber *totalComment;
//性别
@property (nonatomic, copy) NSString *gender;
//优惠活动
@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy, readonly) NSArray *thumbnailUrls;

@property (nonatomic, copy, readonly) NSArray *originalUrls;
/**
 合并后的价格
 */
@property (nonatomic,copy,readonly) NSString *totalPrice;

//图片高度存储,计算得到
@property (nonatomic,strong) NSArray <NSNumber *>* imgHeights;
- (CGFloat)detailHeight;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end

