//
//  PublishVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PublishVC.h"
#import "PublishView.h"
#import "SetPriceView.h"
#import "PublishCategoryVC.h"

//照片
#import "TLImagePickerController.h"
#import <Photos/Photos.h>
#import "UIImage+Custom.h"

#import "QNUploadManager.h"
#import "QNConfiguration.h"
#import "QNResponseInfo.h"

#import "TLPhotoCell.h"
#import "TLPhotoChooseView.h"

#import "TLPhotoChooseItem.h"
#import "TLChooseResultManager.h"
#import "ZipImg.h"
//定位
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PublishVC ()<TLImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
//发布
@property (nonatomic, strong) PublishView *publishView;
//填写价格
@property (nonatomic, strong) SetPriceView *priceView;

@property (nonatomic, weak) id<TLImagePickerControllerDelegate> delegate;
//用于展示已经选择图片的视图
@property (nonatomic, strong) TLPhotoChooseView *photoChooseView;

@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *>*items;
//分类
@property (nonatomic, strong) PublishCategoryModel *category;
//价格
@property (nonatomic, strong) PriceModel *priceModel;

//定位
@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,assign) BOOL isLocationSuccess;

@property (nonatomic,copy) NSString *lon;

@property (nonatomic,copy) NSString *lat;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@end

@implementation PublishVC
{
    dispatch_group_t _uploadGroup;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self startUpdateLocation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布";
    
    _uploadGroup = dispatch_group_create();
    
    self.items = [NSMutableArray array];
    
    [self initRightItem];
    
    [self initPublishView];
    
    [self initSetPriceView];
}

#pragma mark - Init

- (TLPhotoChooseView *)photoChooseView {
    
    if (!_photoChooseView) {
        
        BaseWeakSelf;
        
        [self.publishView.addPhotoBtn removeFromSuperview];
        
        _photoChooseView = [[TLPhotoChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 107.5) type:PhotoSortTypeScroll];
        
        [_photoChooseView setAddAction:^{
            
            TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
            imagePickerController.pickerDelegate = weakSelf;
            //要把已经选中的图片回源，显示已经展示的图片
            imagePickerController.replacePhotoItems = weakSelf.photoChooseView.currentPhotoItems;
            //
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        }];
        
        [self.publishView.photoView addSubview:_photoChooseView];
        
    }
    return _photoChooseView;
}

- (void)initRightItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"取消" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(clickCancel)];
}

- (void)initPublishView {
    
    BaseWeakSelf;
    
    self.publishView = [[PublishView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.publishView.publishBlock = ^(PublishType type) {
        
        switch (type) {
                
            case PublishTypeAddPhoto:
            {
                TLImagePickerController *imagePickerController = [[TLImagePickerController alloc] init];
                imagePickerController.pickerDelegate = weakSelf;
                
                //要把已经选中的图片回源，显示已经展示的图片
                imagePickerController.replacePhotoItems = nil;
                
                //
                [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
            }break;
                
            case PublishTypeAddPrice:
            {
                [weakSelf.priceView show];
                
            }break;
                
            case PublishTypeSelectAddress:
            {
                
            }break;
                
            case PublishTypeSelectCategory:
            {
                PublishCategoryVC *categoryVC = [PublishCategoryVC new];
                
                categoryVC.categoryBlock = ^(PublishCategoryModel *category) {
                    
                    UILabel *categoryLbl = [weakSelf.publishView viewWithTag:1200];
                    
                    categoryLbl.text = category.name;
                    
                    weakSelf.category = category;
                    
                };
                
                [weakSelf.navigationController pushViewController:categoryVC animated:YES];
                
            }break;
                
            case PublishTypePublish:
            {
                [weakSelf publish];
                
            }break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:self.publishView];
}

- (void)initSetPriceView {
    
    BaseWeakSelf;
    
    self.priceView = [[SetPriceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    self.priceView.freightType = self.freightType;
    
    self.priceView.done = ^(PriceModel *priceModel) {
        
        UILabel *textLbl = (UILabel *)[weakSelf.view viewWithTag:1201];
        
        if (priceModel.price) {
            
            textLbl.text = [NSString stringWithFormat:@"￥%@", priceModel.price];
        }
        weakSelf.priceModel = priceModel;
        
    };
}
#pragma mark - 定位
- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 300.0;
        //        [_sysLocationManager requestLocation]; //只定为一次
        
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

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
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
        
        NSString *address;
        
        if (!self.city || !self.area) {
            
            address = @"定位失败";
            
        } else {
            
            address = [NSString stringWithFormat:@"%@ %@", self.city, self.area];
        }
        
        [self.publishView.addressBtn setTitle:address forState:UIControlStateNormal];
        
        CGFloat width = [NSString getWidthWithString:address font:15.0];
        
        self.publishView.addressBtn.width = width;
    }];
    
}

#pragma mark - Events
- (void)clickCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publish {
    
    [self.view endEditing:YES];
    
    if (self.items.count == 0) {
        
        [TLAlert alertWithInfo:@"请添加商品图片"];
        return ;
    }
    
    NSString *title = self.publishView.titleTF.text;
    
    NSString *content = self.publishView.contentTV.text;
    
    if (title.length == 0) {
        
        [TLAlert alertWithInfo:@"商品标题未填写"];
        return ;
        
    } else if (title.length > 30) {
        
        [TLAlert alertWithInfo:@"商品标题最多30个字\n请在下方填写详细描述"];
        
        return ;
    }
    
    if (content.length == 0) {
        
        [TLAlert alertWithInfo:@"商品描述未填写"];
        
        return ;
    }
    
    if (!self.city || !self.area) {
        
        [TLAlert alertWithInfo:@""];
        return ;
    }
    
    if (!self.category) {
        
        [TLAlert alertWithInfo:@"请选择商品分类"];
        return ;
    }
    
    if (!self.priceModel.price) {
        
        [TLAlert alertWithInfo:@"请输入商品价格"];
        return ;
    }
    
    if (!self.priceModel.originPrice) {
        
        [TLAlert alertWithInfo:@"请输入商品原价"];
        return ;
    }
    
    if (!self.priceModel.freightFee) {
        
        [TLAlert alertWithInfo:@"请输入商品运费"];
        return ;
    }
    
    [self photoStatus];
    
}

- (void)photoStatus {
    
    //图片上传
    //获取图片名称
    
    [TLProgressHUD showWithStatus:@"上传图片中"];

    [self.photoChooseView getImgs:^(NSArray<UIImage *> *imgs) {
        
        NSMutableArray *imgNames = [[NSMutableArray alloc] initWithCapacity:imgs.count];
        __block NSInteger uploadSuccessCount = 0;
        [imgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [imgNames addObject:[obj getUploadImgName]];
            
        }];
        
        //---//
        TLNetworking *getUploadToken = [TLNetworking new];
        getUploadToken.code = IMG_UPLOAD_CODE;
        getUploadToken.parameters[@"token"] = [TLUser user].token;
        [getUploadToken postWithSuccess:^(id responseObject) {
            
            //
            NSString *token = responseObject[@"data"][@"uploadToken"];
            //
            QNUploadManager *qnUoloadManange = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                
                builder.zone = [QNZone zone2];
                
            }]];
            //可直接上传PHAsset 以后优化
            
            [imgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                dispatch_group_enter(_uploadGroup);
                [qnUoloadManange putData:UIImageJPEGRepresentation(obj, 1) key:imgNames[idx] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    dispatch_group_leave(_uploadGroup);
                    
                    if (key && !info.error) {
                        uploadSuccessCount ++;
                    }
                    
                } option:nil];
                
            }];
            
            dispatch_group_notify(_uploadGroup, dispatch_get_main_queue(), ^{
                
                [TLProgressHUD dismiss];
                
                if (uploadSuccessCount) {
                    //拼接图片
                    NSString *pic = [imgNames componentsJoinedByString:@"||"];
                    
                    [self publishWithPhoto:pic];
                    
                } else {
                    
                    [TLAlert alertWithError:@"上传图片失败"];
                }
            });
            
        } failure:^(NSError *error) {
            
            [TLProgressHUD dismiss];
            
        }];
    }];
    
}

- (void)publishWithPhoto:(NSString *)photo {
    
    NSString *title = self.publishView.titleTF.text;
    
    NSString *content = self.publishView.contentTV.text;
    
    //switch
    UISwitch *sw = (UISwitch *)[self.publishView viewWithTag:1302];
    //全新
    UIButton *btn = self.publishView.goodBtn;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808015";
    http.showView = self.view;
    
    if (self.activityCode) {
        
        http.parameters[@"activityCode"] = self.activityCode;
    }
    
    http.parameters[@"province"] = self.province;
    http.parameters[@"city"] = self.city;
    http.parameters[@"area"] = self.area;
    http.parameters[@"pic"] = photo;
    http.parameters[@"name"] = title;
    http.parameters[@"description"] = content;
    http.parameters[@"type"] = self.category.code;
    http.parameters[@"price"] = [self.priceModel.price convertToSysMoney];
    http.parameters[@"originalPrice"] = [self.priceModel.originPrice convertToSysMoney];
    http.parameters[@"yunfei"] = [self.priceModel.freightFee convertToSysMoney];
    http.parameters[@"storeCode"] = [TLUser user].userId;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"isNew"] = btn.selected ? @"1": @"0";
    http.parameters[@"isPublish"] = sw.on ? @"1": @"0";
    http.parameters[@"kind"] = @"1";
    http.parameters[@"latitude"] = self.lat;
    http.parameters[@"longitude"] = self.lon;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"发布成功"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (_publishSuccess) {
            
            _publishSuccess();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshData" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark- 图片选择的代理
- (void)imagePickerControllerDidCancel:(TLImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TLImagePickerController *)picker didFinishPickingWithImages:(NSArray <UIImage *> *)imgs chooseItems:(NSMutableArray<TLPhotoChooseItem *> *)items{
    
    //--//
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.items = items;
    
    [self.photoChooseView finishChooseWithImgs:items.copy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
