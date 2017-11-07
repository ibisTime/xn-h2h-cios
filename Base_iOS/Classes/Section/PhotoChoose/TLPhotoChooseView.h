//
//  TLPhotoChooseView.h
//  CityBBSS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLPhotoChooseItem.h"

typedef NS_ENUM(NSInteger, PhotoSortType) {
    
    PhotoSortTypeSquared = 0,  //九宫格
    PhotoSortTypeScroll,      //滚动
};

@interface TLPhotoChooseView : UIView

@property (nonatomic, copy) void(^addAction)();

@property (nonatomic, copy, readonly, getter=getPhotoItems) NSArray <TLPhotoChooseItem *>*currentPhotoItems;

@property (nonatomic, assign) PhotoSortType sortType;

- (instancetype)initWithFrame:(CGRect)frame type:(PhotoSortType)type;

- (void)getImgs:(void(^)(NSArray <UIImage *>*imgs))imgsBLock;

- (void)finishChooseWithImgs:(NSArray <TLPhotoChooseItem *>*)imgs;


@end
