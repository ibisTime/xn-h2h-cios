//
//  HomeGoodListVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HomeGoodListVC.h"

#import "GoodTableView.h"
#import "GoodListCell.h"
#import "GoodModel.h"

#import "GoodDetailVC.h"
//定位
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeGoodListVC ()<CLLocationManagerDelegate>

@property (nonatomic, strong) GoodTableView *tableView;
//商品数据
@property (nonatomic,strong) NSMutableArray <GoodModel *>*goods;
//helper
@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic, assign) BOOL isFirst;
//定位
@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,assign) BOOL isLocationSuccess;
//经度
@property (nonatomic,copy) NSString *lon;
//纬度
@property (nonatomic,copy) NSString *lat;
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//区
@property (nonatomic, copy) NSString *area;

@end

@implementation HomeGoodListVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirst = YES;

    //商品
    [self initTableView];
    //获取商品列表
    [self requesGoodList];
    
    //添加通知
    [self addNotification];

    
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
    
    [self.sysLocationManager  startUpdatingLocation];
}

#pragma mark - Init
- (void)initTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[GoodTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight - kBottomInsetHeight)];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品" topMargin:42];
    
    self.tableView.goodBlock = ^(NSIndexPath *indexPath) {
        
        GoodModel *good = weakSelf.goods[indexPath.row];
        
        GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
        
        detailVC.code = good.code;
        detailVC.userId = good.storeCode;

        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    [self.view addSubview:self.tableView];
    
}

- (void)addNotification {
    //商品被购买触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshData" object:nil];
    //点击按钮时触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RefreshScrollViewData" object:nil];
    //首页刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodData) name:@"RefreshGoodData" object:nil];
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
    self.helper.parameters[@"longitude"] = self.lon;

    //
    self.lat = [NSString stringWithFormat:@"%.10f",location.coordinate.latitude];
    self.helper.parameters[@"latitude"] = self.lat;

    //地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        self.province = placemark.addressDictionary[@"State"];
        
        self.city = placemark.addressDictionary[@"City"];
        
        self.area = placemark.addressDictionary[@"SubLocality"];
        
    }];
    
    [self requesGoodList];

    
}

#pragma mark - Notification
- (void)refreshData {
    
    if (_status == HomeGoodStatusNearbyGood) {
        //定位
        [self startUpdateLocation];
        
        return ;
    }
    
    [self requesGoodList];
}

- (void)refreshGoodData {
    
    [self requesGoodList];
}

#pragma mark - Data
- (void)requesGoodList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    if (_status == HomeGoodStatusHotGood) {
        
        helper.code = @"808025";
        helper.parameters[@"location"] = @"1";

    } else {
        
        helper.code = @"808020";
        helper.parameters[@"start"] = @"1";
        helper.parameters[@"limit"] = @"20";
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.parameters[@"status"] = @"3";
    //是否参加活动
    helper.parameters[@"isJoin"] = @"0";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[GoodModel class]];
    
    self.helper = helper;
    
    //店铺数据
    [helper refresh:^(NSMutableArray <GoodModel *>*objs, BOOL stillHave) {
        
        weakSelf.goods = objs;
        
        weakSelf.tableView.goods = objs;
        
        [weakSelf.tableView reloadData_tl];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDidFinish" object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
//    [self.tableView addRefreshAction:^{
//
//
//    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.goods = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    //--//
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
