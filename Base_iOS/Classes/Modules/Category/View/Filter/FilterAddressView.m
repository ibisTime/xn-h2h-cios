//
//  FilterAddressView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "FilterAddressView.h"
#import "Province.h"
#import "FilterAddressModel.h"
//定位
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FilterAddressView ()<UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate>
//头部
@property (nonatomic, strong) UIView *headerView;
//省
@property (nonatomic, strong) TLTableView *provinceTableView;
//市
@property (nonatomic, strong) TLTableView *cityTableView;
//区
@property (nonatomic, strong) TLTableView *areaTableView;


@property (nonatomic ,strong) NSMutableArray * pArr;/**< 地址选择器数据源,装省份模型,每个省份模型内包含城市模型*/

@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSMutableArray <FilterProvince *>* provincesArr;/**< 省份名称数组*/
@property (nonatomic ,strong) NSMutableArray <FilterCity *>* citysArr;/**< 所有城市的数组*/
@property (nonatomic ,strong) NSMutableArray <FilterDistrict *>* areasArr;/**< 所有地区的数组*/

@property (nonatomic, strong) FilterAddressModel *addressModel;

//当前位置
@property (nonatomic, strong) UIButton *currentAddressBtn;

//定位
@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,assign) BOOL isLocationSuccess;

@property (nonatomic,copy) NSString *lon;

@property (nonatomic,copy) NSString *lat;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@end

@implementation FilterAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.provincesArr = [NSMutableArray array];
        
        self.citysArr = [NSMutableArray array];
        
        self.areasArr = [NSMutableArray array];
        
        //头部
        [self initHeaderView];
        //
        [self initTableView];
        //加载地址数据
        [self loadAddressData];
        //定位
        [self startUpdateLocation];
    }
    
    return self;
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.alpha = 0;

    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.4];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.headerView];
    
    //text
    UIButton *textBtn = [UIButton buttonWithTitle:@"当前位置" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:11.0];
    
    [textBtn setImage:kImage(@"address") forState:UIControlStateNormal];
    
    textBtn.frame = CGRectMake(15, 15, 70, 13);
    
    [textBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -6)];
    
    [self.headerView addSubview:textBtn];
    //当前位置
    self.currentAddressBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:13.0];
    
    self.currentAddressBtn.frame = CGRectMake(15, textBtn.yy, 0, 40);
    
    [self.currentAddressBtn addTarget:self action:@selector(selectCurrentAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:self.currentAddressBtn];
    //刷新
    UIButton *refreshBtn = [UIButton buttonWithTitle:@"刷新" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:13.0];
    
    [refreshBtn setImage:kImage(@"刷新") forState:UIControlStateNormal];
    
    refreshBtn.frame = CGRectMake(kScreenWidth - 10 - 60, 0, 60, 68);
    
    [refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];

    [refreshBtn addTarget:self action:@selector(refreshAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:refreshBtn];
}

- (void)initTableView {
    //省
    self.provinceTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];

    self.provinceTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];

    self.provinceTableView.frame = CGRectMake(0, self.headerView.yy, 90, 360);
    
    [self addSubview:self.provinceTableView];
    
    //市
    self.cityTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
//    self.cityTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分类"];
    self.cityTableView.backgroundColor = [UIColor whiteColor];
    
    self.cityTableView.frame = CGRectMake(self.provinceTableView.xx, self.headerView.yy, 100, 360);

    [self addSubview:self.cityTableView];
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_equalTo(0);
        make.left.mas_equalTo(self.cityTableView.mas_right).mas_equalTo(0);
        make.height.mas_equalTo(360);
        make.width.mas_equalTo(0.5);
        
    }];
    //区
    self.areaTableView = [TLTableView tableViewWithFrame:CGRectZero delegate:self dataSource:self];
//    self.areaTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无分类"];
    self.areaTableView.backgroundColor = [UIColor whiteColor];
    
    self.areaTableView.frame = CGRectMake(self.cityTableView.xx, self.headerView.yy, kScreenWidth - self.cityTableView.xx, 360);

    [self addSubview:self.areaTableView];
}

#pragma mark - 定位
- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 300.0;
        
    }
    
    return _sysLocationManager;
}

- (void)startUpdateLocation {
    
    if (![TLAuthHelper isEnableLocation]) {
        
        [TLAlert alertWithTitle:@"" msg:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [TLAuthHelper openSetting];
            
        }];
        
        return;
        
    }
    
    [self.sysLocationManager startUpdatingLocation];
}

#pragma mark - Events
- (void)selectCurrentAddress {
    
    [self hide];
}

//刷新地址
- (void)refreshAddress {
    
    [self startUpdateLocation];
    
    [TLProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];
    });
}

#pragma mark - 加载地址数据
- (void)loadAddressData {
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"addressJSON"
                                                          ofType:@"txt"];
    
    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
    _dataDict = [self dictionaryWithJsonString:str22];
    
    if (!_dataDict) {
        return;
    }
    
    self.addressModel = [FilterAddressModel new];
    
    self.addressModel.province = [FilterProvince mj_objectArrayWithKeyValuesArray:_dataDict[@"province"]];
    
    ;
    
    FilterProvince *province = [FilterProvince new];
    
    province.name = @"全国";
    
    [self.provincesArr addObject:province];
    
    [self.provincesArr addObjectsFromArray:self.addressModel.province];
    
    [self.provinceTableView reloadData_tl];
}

#pragma mark - 解析json

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    FilterManager *filter = [FilterManager manager];

    filter.province = self.province;
    filter.city = self.city;
    filter.area = self.area;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (_done) {
            
            _done();
        };
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    [TLProgressHUD dismiss];
    [TLAlert alertWithError:@"定位失败"];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [TLProgressHUD dismiss];

    //获取当前位置
    CLLocation *location = manager.location;
    
    self.lon = [NSString stringWithFormat:@"%.10f",location.coordinate.longitude];
    //
    self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    
    //地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        self.province = placemark.addressDictionary[@"State"];
        
        self.city = placemark.addressDictionary[@"City"];
        
        self.area = placemark.addressDictionary[@"SubLocality"];
        
        NSString *address = [NSString stringWithFormat:@"%@ %@", self.city, self.area];
        
        [self.currentAddressBtn setTitle:address forState:UIControlStateNormal];
        
        CGFloat width = [NSString getWidthWithString:address font:15.0];
        
        self.currentAddressBtn.width = width;
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.provinceTableView]) {
        
        return self.provincesArr.count;
        
    } else if ([tableView isEqual:self.cityTableView]) {
        
        return self.citysArr.count;
        
    } else {
        
        return self.areasArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.provinceTableView]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvinceCellID"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProvinceCellID"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
        }
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIColor whiteColor] convertToImage]];
        
        cell.textLabel.textColor = kTextColor2;
        
        cell.textLabel.font = Font(13.0);
        
        FilterProvince *province = self.provincesArr[indexPath.row];
        
        cell.textLabel.text = province.name;
        
        UIView *selectBgView = [[UIView alloc] initWithFrame:cell.frame];
        
        selectBgView.backgroundColor = kWhiteColor;
        
        cell.selectedBackgroundView = selectBgView;
        
        cell.textLabel.highlightedTextColor = kTextColor;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kAppCustomMainColor;
        [selectBgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(2.5);
            make.centerY.mas_equalTo(0);
        }];
        
        return cell;
        
    } else if ([tableView isEqual:self.cityTableView]){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellId"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCellId"];
            
        }
    
        FilterCity *city = self.citysArr[indexPath.row];
        
        cell.textLabel.text = city.name;
        
        cell.textLabel.font = Font(13.0);
        cell.textLabel.textColor = kTextColor2;
        cell.textLabel.highlightedTextColor = kTextColor;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCellId"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AreaCellId"];
            
        }
        
        FilterDistrict *area = self.areasArr[indexPath.row];
        
        cell.textLabel.text = area.name;
        cell.textLabel.font = Font(13.0);
        cell.textLabel.textColor = kTextColor2;
        cell.textLabel.highlightedTextColor = kTextColor;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //right
    if ([tableView isEqual:self.cityTableView]) {
        
        self.areasArr = self.citysArr[indexPath.row].district.mutableCopy;

        [self.areaTableView reloadData];
        
        FilterCity *city = self.citysArr[indexPath.row];
        
        self.city = city.name;
        
    } else if ([tableView isEqual:self.areaTableView]) {
        
        FilterDistrict *area = self.areasArr[indexPath.row];
        
        self.area = area.name;
        
        [self hide];
        
    } else {
        
        if (indexPath.row != 0) {
            
            FilterProvince *province = self.provincesArr[indexPath.row];
            
            self.province = province.name;
            
            self.citysArr = self.provincesArr[indexPath.row].city.mutableCopy;
            
            [self.cityTableView reloadData];
            
            self.areasArr = nil;
            
            [self.areaTableView reloadData];
            
        } else {
            
            FilterProvince *province = self.provincesArr[indexPath.row];
            
            self.province = province.name;
            
            [self hide];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
    
}

@end
