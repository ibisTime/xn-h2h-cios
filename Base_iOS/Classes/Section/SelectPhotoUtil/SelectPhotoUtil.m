//
//  SelectPhotoUtil.m
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/9.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "SelectPhotoUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "UIImage+Custom.h"

@interface SelectPhotoUtil () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) SuccessBlock successBlock;

@end

@implementation SelectPhotoUtil 


+ (instancetype)shareInstance {

    static dispatch_once_t onceToken;
    static SelectPhotoUtil *instance = nil;
    dispatch_once(&onceToken, ^{
       
        instance = [[SelectPhotoUtil alloc] init];
    });

    return instance;
}



- (void)selectImageViewWithViewController:(BaseViewController*)viewController success:(SuccessBlock)success {

    
    _successBlock = [success copy];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:NULL message:NULL preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断设备是否支持拍照功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied) {
                
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未获取到相机权限，请在“设置->隐私->相机”中开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
                [alertCtrl addAction:submitAction];
                [viewController presentViewController:alertCtrl animated:YES completion:nil];
            }
            else {
                UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
                imagePC.allowsEditing = YES;
                imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePC.delegate = self;
                imagePC.navigationBar.backgroundColor = [UIColor whiteColor];
                
                [viewController presentViewController:imagePC animated:YES completion:nil];
            }
        }
        else {
            
            [TLAlert alertWithInfo:@"该设备不支持拍摄功能"];
        }
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.allowsEditing = YES;
        imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePC.delegate = self;
        imagePC.navigationBar.backgroundColor = [UIColor whiteColor];
        
        [viewController presentViewController:imagePC animated:YES completion:nil];
    }];
    
    UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCtrl addAction:cameraAction];
    [alertCtrl addAction:photoAction];
    [alertCtrl addAction:canleAction];
    
    [viewController presentViewController:alertCtrl animated:YES completion:^{
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *newImage = [UIImage getHumbnailImage:image scaledToSize:CGSizeMake(200,image.size.height/image.size.width*200)];

        if (_successBlock) {
            _successBlock(newImage);
        }
    }];
}



@end
