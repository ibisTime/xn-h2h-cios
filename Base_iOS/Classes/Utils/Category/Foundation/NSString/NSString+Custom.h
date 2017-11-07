//
//  NSString+Custom.h
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

// 处理空字符串
+ (NSString *)convertNullOrNil:(NSString *)str;

// 根据指定格式将 NSDate 转换为 NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

// 根据指定格式将 NSString 转换为 NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

// 根据时间戳得到时间字符串
+ (NSString*)stringFromTimeStamp:(NSString*)timeStampStr;

// 根据时间格式和时间戳字符串 获取时间字符串
+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter;

// 根据字符串时间戳获取日历DateComponents
- (NSDateComponents*)timeIntetvalStringToDateComponents;

// 获取当前时间的日历
+ (NSDateComponents*)getCurrentComponents;

// 根据时间戳得到字符串
+ (NSString*)stringWithTimeStamp:(NSString *)timeStampStr;


// 根据时间格式和时间戳字符串 获取时间字符串
+ (NSString*)stringWithTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter;

//根据字符串和字符串时间格式获取指定时间格式字符串
+ (NSString *)stringWithTimeString:(NSString *)timeString timeFormatter:(NSString *)timeFormatter fotmatter:(NSString *)formatter;

//根据时间获取指定的时间
+ (NSString *)stringWithTimeStr:(NSString *)timeStampStr format:(NSString *)format;

// 验证手机号码合法性（正则）
+ (BOOL)isValidatePhoneNumber:(NSString *)phoneNumber;

// 验证邮箱合法性（正则）
- (BOOL)isValidateEmail;

// 序列化JSON
+ (NSString *)serializeMessage:(id)message;

// 反序列化JSON
+ (id)deserializeMessageJSON:(NSString *)messageJSON;

//通过正则表达式截取字符串
+ (NSString *)stringWithRegularExpression:(NSString *)regularStr string:(NSString *)string;

//MD5加密
+ (NSString *)MD5:(NSString *)sourceString;

//计算文字frame
- (CGSize)getSizeForTextWithFont:(float)font size:(CGSize)size;

//拼接图片域名
+ (NSString*)appendImageServiceDomain:(NSString*)imgStr;

//根据返回的结果状态码，返回原因
+ (NSString *)stringWithReturnCode:(NSInteger)returnCode;

- (NSString *)URLEncodedString;

- (NSString*)decodeHtmlString;

//获取当前本地时间
+ (NSDate *)getLocalDate;

//判断字符串是否为纯数字

+ (BOOL)isPureNumWithString:(NSString *)string;

//验证银行卡号
+ (BOOL)checkCardNo:(NSString*) cardNo;
- (BOOL)bankCardluhmCheck;

//转换成正确的字符串
- (NSString *)convertToRealMoney;

//快递转义
- (NSString *)getExpressName;

- (NSString *)getRefereeName;

- (NSString *)getRefereeType;

@end
