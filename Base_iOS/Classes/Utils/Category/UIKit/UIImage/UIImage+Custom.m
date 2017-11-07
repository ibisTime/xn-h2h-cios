//
//  UIImage+Custom.m
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/22.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

//创建抗锯齿头像
- (UIImage*)antialiasedImage {
    return [self antialiasedImageOfSize:self.size scale:self.scale];
}

//创建抗锯齿头像,并调整大小和缩放比。
- (UIImage*)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale {
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(1, 1, size.width-5, size.height-5)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (UIImage*)getHumbnailImage:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)getUploadImgName {
    
    if (!self) {
        NSLog(@"图片不能为nil");
        return nil;
    }
    CGSize imgSize = self.size;//
    
    NSDate *now = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%f",now.timeIntervalSince1970];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *imageName = [NSString stringWithFormat:@"iOS_%@_%.0f_%.0f.jpg",timestamp,imgSize.width,imgSize.height];
    
    return imageName;
    
    
}

@end
