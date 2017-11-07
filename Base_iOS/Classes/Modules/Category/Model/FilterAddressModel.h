//
//  FilterAddressModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class FilterProvince,FilterCity,FilterDistrict;

@interface FilterAddressModel : BaseModel

@property (nonatomic, strong) NSArray<FilterProvince *> *province;

@end

@interface FilterProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<FilterCity *> *city;

@end

@interface FilterCity : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<FilterDistrict *> *district;

@end

@interface FilterDistrict : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *zipcode;

@end

