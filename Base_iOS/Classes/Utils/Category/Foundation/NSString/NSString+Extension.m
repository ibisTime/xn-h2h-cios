//
//  NSString+Extension.m
//  OMMO
//
//  Created by haiqingzheng on 15/12/7.
//  Copyright © 2015年 OMMO. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppConfig.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <sys/sysctl.h>
#import <sys/socket.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSString (Extension)

- (BOOL)isPhoneNum {

   NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"^1[3,4,5,7,8]\\d{9}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *regStr = @"^1[3,4,5,7,8]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
   return [predicate evaluateWithObject:str];

}

- (BOOL)isBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (s == nil || [s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isNotBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(s != nil && ![s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isBlankName
{
    if (self.length <= 0 || self.length > 40) {
        return NO;
    }
    
    if ([self isChinese]) {
        return YES;
    } else {
        return NO;
    }

}

- (NSAttributedString *)attrStr {

    return [[NSAttributedString alloc] initWithString:self];

}
- (NSString *)convertThumbnailImageUrl{
//  限定长边，生成不超过 300x300 的缩略图
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
       return  [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip/thumbnail/150x150/quality/60!",[AppConfig config].qiniuDomain,self] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
}

- (CGSize)imgSizeByImageName:(NSString *)imageName {

    if ([imageName hasPrefix:@"http"]) {
       
        return CGSizeMake(4,3);
        
    } else {
    
        if ([imageName hasSuffix:@".jpg"] || [imageName hasSuffix:@".png"]) {
            
          NSString *urlName = [imageName substringWithRange:NSMakeRange(0, imageName.length - 4)];
          NSArray *arr = [urlName componentsSeparatedByString:@"_"];
            
          if (arr.count > 2) {
                
                CGFloat h = [arr[arr.count - 1] floatValue];
                CGFloat w = [arr[arr.count - 2] floatValue];
                return CGSizeMake(w, h);
          } else {
          
              return CGSizeMake(4, 3);

          }
            
        } else if ([imageName hasSuffix:@".jpeg"]) {
            
            NSString *urlName = [imageName substringWithRange:NSMakeRange(0, imageName.length - 5)];
            NSArray *arr = [urlName componentsSeparatedByString:@"_"];
            
            if (arr.count > 2) {
                
                CGFloat h = [arr[arr.count - 1] floatValue];
                CGFloat w = [arr[arr.count - 2] floatValue];
                return CGSizeMake(w, h);
            } else {
            
                return CGSizeMake(4, 3);

            }
            
        } else {
        
            return CGSizeMake(4, 3);
        }
    
    }

}

- (NSString *)convertImageUrl {

    //auto-orient 根据原信息 旋转
    //strip 取出图片原信息
  return  [self convertImageUrlWithScale:75];

}

- (NSString *)convertOriginalImgUrl {

    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
        return  [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip",[AppConfig config].qiniuDomain,self] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }

}

//scale 0-100
- (NSString *)convertImageUrlWithScale:(NSInteger)scale {

    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
//        return [[@"http:/7xnuu2.com1.z0.glb.clouddn.com/" add:self] add:@"?imageMogr2/auto-orient/strip/quality/50!"];
     return  [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip/quality/%ld!",[AppConfig config].qiniuDomain,self,scale] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }

}


- (BOOL)isBankCardNo
{
    if ([self isDigital]) {
        
        if (self.length >= 16 && self.length <= 30) {
            
            return YES;
            
        } else {
            
            return NO;
        }
        
    } else {
        
        return NO;
        
    }
    
}

- (BOOL)isDigital:(NSUInteger)length
{
//    ^\d{n}$ n为数字
//    ^[0-9]*$ 是否为数字
    if (length == 18) {
        return YES;
    }
    
    BOOL result = false;
    NSString *regex = [NSString stringWithFormat:@"^\\d{%ld}$",length];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
    
}

- (BOOL)isDigital
{
    //    ^\d{n}$ n为数字
    //    ^[0-9]*$ 是否为数字
    if(0 == self.length) return NO;
    
    BOOL result = false;
    NSString *regex =@"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}


- (BOOL)isDigitalOrLetter
{
    if (self.length == 0) {
        return NO;
    }
    BOOL result = false;
    NSString *regex =@"^[0-9a-zA-Z]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

- (BOOL)isLegal
{
    if (!self.length) {
        return NO;
    }
    BOOL result = false;
    NSString *regex = @"^[A-Za-z0-9\u3400-\u9FFF_-]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];

    return result;
    
}

- (BOOL)isChinese
{
    if (![self valid]) {
        return NO;
    }
    
    BOOL flag = YES;
     for(int i=0; i< [self length];i++)
     {
//       \u3400  \u9fcc
         int a = [self characterAtIndex:i];
         if( a >= 0x3400 && a <= 0x9fff){
         
         } else {
             flag = NO;
         }
     }
    return flag;
}

- (NSString *)md5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

//获取app版本号
+ (NSString *)appVersionString {

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)valid {

    return  self != nil && self.length > 0;

}

- (NSString *)vaildString {

    if (self == nil || [self isKindOfClass:[NSNull class]]) {
        
        return @"";
    }
    
    return self;
}

- (CGSize)calculateStringSize:(CGSize)size font:(UIFont *)font
{
    CGSize stringSize;
    NSDictionary *dict = @{
                           NSFontAttributeName:font
                           };
    stringSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return stringSize;
}

- (NSString *)add:(NSString *)appendStr {

    return [self stringByAppendingString:appendStr];
}

- (BOOL)greaterThan:(NSNumber *)num {

    CGFloat v = [self floatValue];
    CGFloat t0 = v*1000;
    long long money = (long long)t0;
    if (money - [num longLongValue] > 0) {
        return YES;
    } else {
    
        return NO;
    }

}

- (BOOL)greaterThanOrEqual:(NSNumber *)num {

    if (!self) {
        return NO;
    }
    
    CGFloat v = [self floatValue];
    CGFloat t0 = v*1000;
    long long money = (long long)t0;
    if (money - [num longLongValue] >= 0) {
        return YES;
    } else {
        
        return NO;
    }

}




- (NSString *)convertToSysMoney {

    double v = [self doubleValue];
    double t0 = v*1000;
    long long money = (long long)t0;
    return [NSString stringWithFormat:@"%lld",money];
}

- (NSString *)convertToTimelineDate {

    //后期改为类似于微信的那种做法
    return  [self convertToDetailDate];

}

- (NSString *)convertToDetailDate {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
    
}


- (NSString *)convertDate {

    return [self converDate];
}


- (NSString *)converDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
}

- (NSString *)convertDateWithFormat:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:self];
    formatter.dateFormat = format;
    formatter.locale = [NSLocale currentLocale];
    
    return [formatter stringFromDate:date01];
    
}

+ (NSString *)getWifiMacAddress {
    
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    
    id info = nil;
    
    for (NSString *ifname in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifname);
        
        if (info && [info count]) {
            
            break;
        }
    }
    
    NSDictionary *dic = (NSDictionary *)info;
    
    NSString *wifiMacAddress = [dic objectForKey:@"BSSID"];
    
    NSArray *mac = [wifiMacAddress componentsSeparatedByString:@":"];
    
    NSMutableString *wifiAddress = [NSMutableString string];
    
    
    for (int i = 0 ; i < mac.count; i++) {
        
        NSString *sub = mac[i];
        
        if (sub.length == 1) {
            
            [wifiAddress appendString:[NSString stringWithFormat:@"0%@", sub]];
            
        } else {
            
            [wifiAddress appendString:sub];
            
        }
    }
    
    return wifiAddress;
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(CGFloat)font {
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}];
    //获取宽高
    CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return statuseStrSize.width;
}

@end
