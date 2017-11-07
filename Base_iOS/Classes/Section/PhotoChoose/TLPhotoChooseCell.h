//
//  TLPhotoChooseCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TLPhotoItem.h"
#import "TLPhotoChooseItem.h"

@interface TLPhotoChooseCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteItem)(TLPhotoChooseItem *photoItem);

@property (nonatomic, strong) TLPhotoChooseItem *photoItem;



@end
