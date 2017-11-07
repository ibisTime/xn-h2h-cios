//
//  GoodModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"productSpecsList" : [CDGoodsParameterModel class]};
    
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

- (NSString *)advPic {
    
    return self.pics[0];
}

- (void)setPic:(NSString *)pic {

    _pic = [pic copy];
    
}

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj convertImageUrl]];
            
        }];
        
        _pics = newImgs;
        
    }
    
    return _pics;
    
}

- (NSArray<NSNumber *> *)imgHeights {
    
    if (!_imgHeights) {
        
        //未经转换的url
        NSArray *urls = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *hs = [NSMutableArray arrayWithCapacity:urls.count];
        
        [urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize size = [obj imgSizeByImageName:obj];
            CGFloat scale = size.width*1.0/size.height;
            
            [hs addObject:@((kScreenWidth - 30)/scale)];
            
        }];
        _imgHeights = hs;
    }
    return _imgHeights;
}

- (CGFloat)detailHeight {
    
    CGSize size  =  [self.desc calculateStringSize:CGSizeMake(kScreenWidth - 30, 1000) font:FONT(13)];
    
    return size.height + 25;
}

- (NSString *)coverMoney:(NSNumber *)priceNum {
    
    NSInteger pr = [priceNum integerValue];
    CGFloat newPr = pr/1000.0;
    return [NSString stringWithFormat:@"%.1f",newPr];
    
}

//神奇
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
}

//

- (NSNumber *)RMB {
    
    if (self.productSpecsList.count > 0) {
        
        return self.productSpecsList[0].price1;
        
    } else {
        
        return @0;
    }
    
}

//圈子
- (NSArray *)thumbnailUrls {
    
    if (self.pics.count > 12) {
        self.pics = [self.pics subarrayWithRange:NSMakeRange(0, 12)];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.pics.count];
    
    [self.pics enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //重要优化，列表要取足够小的缩略图，输出--》 获取足够小的正方形图片
        NSString *imgDomain = [AppConfig config].qiniuDomain;
        
        CGFloat photoH = (kScreenWidth - 15*2 - 2*3)/3.0;
        
        CGFloat photoW_PX = photoH * [UIScreen mainScreen].scale;
        
        //imageView2/1/w/50/h/50/format/jpg/q/75|imageslim
        //
        //imageMogr2/gravity/Center/crop/300x300
        
        //先缩略，在截取正中心 正方形
        //       imageMogr2/auto-orient/strip/thumbnail/!100x100r/gravity/Center/crop/100x100
        
        NSString *imgSizeThumbnailXXXX = [NSString stringWithFormat:@"!%.0lfx%.0lfr",photoW_PX,photoW_PX];
        
        NSString *imgSizeCropXXXX = [NSString stringWithFormat:@"%.0lfx%.0lf",photoW_PX,photoW_PX];
        
        
        NSString *imgUrlStr =
        
        [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip/thumbnail/%@/gravity/Center/crop/%@",imgDomain,obj,imgSizeThumbnailXXXX,imgSizeCropXXXX] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [arr addObject:imgUrlStr];
    }];
    return arr;
    
}

- (NSArray *)originalUrls {
    
    if (self.pics.count > 12) {
        self.pics = [self.pics subarrayWithRange:NSMakeRange(0, 12)];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.pics.count];
    [self.pics enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arr addObject:[obj convertImageUrlWithScale:100]];
        
    }];
    return arr;
    
    
}
@end

