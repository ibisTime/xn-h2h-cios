//
//  NSString+Custom.m
//  Utils
//
//  Created by 蔡卓越 on 15/10/26.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Custom)

+ (NSString *)convertNullOrNil:(NSString *)str {

    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    else if ([str isEqual:[NSNull class]]) {
        str = @"";
    }
    else if (str == nil) {
        str = @"";
    }
    return str;
}

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"]; //NSLocale(localeIdentifier: "en")

    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];

    NSDate *date = [dateFormatter dateFromString:dateString];
    //国际时间
    NSDate* localDate = [[NSDate alloc] init];
    //获得的是计算机上的时间
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    //得到本地时间与国际时间的时间差
    NSInteger interval = [zone secondsFromGMTForDate:localDate];

    return [date dateByAddingTimeInterval:interval];
}

+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter {
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        return @"";
    }
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    return  [NSString stringFromDate:createDate formatter:formatter];
}

+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr {
    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        return nil;
    }
    
    NSString *dataStr = nil;
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    
    dataStr = [NSString stringFromDate:createDate formatter:@"yyyy-MM-dd HH:mm:ss"];
    //dataStr = [NSString stringFromDate:createDate formatter:@"YYYY-MM-dd"];
    NSTimeInterval timeInterval = ABS([createDate timeIntervalSinceNow]);
    if (timeInterval/60 <= 1) {
        dataStr = @"刚刚";
    }
    else if (timeInterval/3600 <= 1) {
        NSInteger minutes = timeInterval/60;
        dataStr = [NSString stringWithFormat:@"%li分钟前", (long)minutes];
    }
    else if (timeInterval/3600/24 <= 1) {
        NSInteger hours = timeInterval/3600;
        dataStr = [NSString stringWithFormat:@"%li小时前", (long)hours];
    }
    else if (timeInterval/3600/24 <= 2) {
        dataStr = @"昨天";
    }
    else if (timeInterval/3600/24 <= 3) {
        dataStr = @"前天";
    }
    
    return dataStr;

}

- (NSDateComponents*)timeIntetvalStringToDateComponents {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;

    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    comps = [calendar components:unitFlags fromDate:date];

    return comps;
}

+ (NSDateComponents*)getCurrentComponents {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *currentDate = [NSDate date];
    comps = [calendar components:unitFlags fromDate:currentDate];
    return  comps;
}

+ (NSString*)stringWithTimeStamp:(NSString*)timeStampStr {

    return [self stringWithTimeStamp:timeStampStr formatter:nil];
}

+ (NSString *)stringWithTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter {

    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        
        return @"";
    }
    
    NSString *timeStr = @"";
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStampStr floatValue]];
    
    if (formatter == nil) {
        
        formatter = @"yyyy.MM.dd HH:mm";
    }
    
    timeStr = [NSString stringFromDate:timeDate formatter:formatter];
    
    return timeStr;
}

+ (NSString *)stringWithTimeString:(NSString *)timeString timeFormatter:(NSString *)timeFormatter fotmatter:(NSString *)formatter {
    
    NSString *timeStr = @"";
    NSDate *date = [NSString dateFromString:timeString formatter:timeFormatter];
    timeStr = [NSString stringFromDate:date formatter:formatter];
    
    return timeStr;
}

+ (NSString *)stringWithTimeStr:(NSString *)timeStampStr format:(NSString *)format {

    if (PASS_NULL_TO_NIL(timeStampStr) == nil) {
        
        return nil;
    }
    
    NSString *dataStr = nil;
    NSDate *createDate = [NSString dateFromString:timeStampStr formatter:format];

    NSDate *localDate = [NSString getLocalDate];
    
    //转换时间格式
    //对比两个时间
    
    NSTimeInterval seconds = [localDate timeIntervalSinceDate:createDate];
    
    if (seconds/3600/24/365 > 1) {
        
        NSInteger year = seconds/3600/24/365;
        
        dataStr = [NSString stringWithFormat:@"%ld年前", year];
    }
    
    if (seconds/3600/24/30 > 1) {
        
        NSInteger month = seconds/3600/24/30;
        
        dataStr = [NSString stringWithFormat:@"%ld月前", month];
    }
    
    if (seconds/3600/24 > 1) {
        
        NSInteger day = seconds/3600/24;
        
        dataStr = [NSString stringWithFormat:@"%ld天前", day];
        
        return dataStr;
    }
    
    if (seconds/60 <= 1) {
        
        dataStr = @"刚刚";
        
    } else if (seconds/60 < 60) {
        
        NSInteger minute = seconds/60;
        
        dataStr = [NSString stringWithFormat:@"%ld分钟前", minute];
        
    } else {
        
        NSInteger hour = seconds/3600;
        
        dataStr = [NSString stringWithFormat:@"%ld小时前", hour];
        
    }
    
    return dataStr;
}

+ (BOOL)isValidatePhoneNumber:(NSString *)mobile {

    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11) {
        
        return NO;
    }
    else {
        
        /**
         
         * 移动号段正则表达式
         
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }
        else {
            
            return NO;
            
        }
    }
}

- (BOOL)isValidateEmail {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (NSString *)stringWithRegularExpression:(NSString *)regularStr string:(NSString *)string {

    NSRange range = [string rangeOfString:regularStr options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        
        return [string substringWithRange:range];
    }
    
    return nil;
}
  //序列化JSON
+ (NSString *)serializeMessage:(id)message {

    NSData *serizlizeData = [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    return [[NSString alloc] initWithData:serizlizeData encoding:NSUTF8StringEncoding];
}

  //反序列化JSON
+ (id)deserializeMessageJSON:(NSString *)messageJSON {

    if (messageJSON) {
        NSData *messageData = [messageJSON dataUsingEncoding:NSUTF8StringEncoding];
     return [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
        
    }
    return nil;
}

//加密大写
//+ (NSString *)MD5:(NSString *)sourceString {
//
//    if ([sourceString isEqualToString:@""] || sourceString == nil) {
//        
//        return @"";
//        
//    }else {
//    
//        const char *cStr = [sourceString UTF8String];
//        unsigned char result[16];
//        CC_MD5( cStr, strlen(cStr), result );
//        return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                result[0], result[1], result[2], result[3],
//                result[4], result[5], result[6], result[7],
//                result[8], result[9], result[10], result[11],
//                result[12], result[13], result[14], result[15]
//                ];
//    }
//}

- (CGSize)getSizeForTextWithFont:(float)font size:(CGSize)size {

    NSString *text = [NSString convertNullOrNil:self];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
    CGRect frame = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return frame.size;
}

+ (NSString*)appendImageServiceDomain:(NSString*)imgStr {
    
    NSString *urlStr = PASS_NULL_TO_NIL(imgStr);
    if (urlStr) {
        
        if ([imgStr hasPrefix:@"http://"] || [imgStr hasPrefix:@"https://"] ) {
            
            imgStr = [imgStr stringByAppendingString:@"?imageMogr2/thumbnail/700x700"];
            return imgStr;
        }
        
//        urlStr = [[Singleton sharedManager].httpImageServiceDomain stringByAppendingString:urlStr];
    }
    else {
        urlStr = @"";
    }
    
    return urlStr;
}

+ (NSString *)stringWithReturnCode:(NSInteger)returnCode {

    NSString *promptStr = @"";
    
    switch (returnCode) {
            
        case 400:
            promptStr = @"分享失败";
            break;
            
        case 505:
            promptStr = @"用户被封禁";
            break;
            
        case 510:
            promptStr = @"发送失败";
            break;
            
        case 522:
            promptStr = @"分享失败";
            break;
            
        case 5007:
            promptStr = @"发送内容为空";
            break;
            
        case 5016:
            promptStr = @"分享内容重复";
            break;
            
        case 5020:
            promptStr = @"分享失败";
            break;
            
        case 5027:
            promptStr = @"分享失败";
            break;
            
        case 5050:
            promptStr = @"网络错误";
            break;
            
        case 5051:
            promptStr = @"获取账户失败";
            break;
            
        case 5052:
            promptStr = @"取消分享";
            break;
            
        case 5053:
            promptStr = @"账号未登录";
            break;
            
        case 100031:
            promptStr = @"分享失败";
            break;

        default:
            break;
    }
    
    return promptStr;
}
//获取当前本地时间
+ (NSDate *)getLocalDate {
    
    //国际时间
    NSDate *date = [[NSDate alloc] init];
    
//    //获得的是计算机上的时间
//    NSTimeZone* zone = [NSTimeZone systemTimeZone];
//    //得到本地时间与国际时间的时间差
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//
//    NSDate *locateDate = [date dateByAddingTimeInterval:interval];
    
    return date;
}

// 编码
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString*)decodeHtmlString {

    if (!PASS_NULL_TO_NIL(self)) {
        return @"";
    }
    
    NSData *stringData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *decodedString;
    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                     options:options
                                          documentAttributes:NULL
                                                       error:NULL];
    return decodedString.string;
}



//纯数字
+ (BOOL)isPureNumWithString:(NSString *)string {

    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if (string.length > 0) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)bankCardluhmCheck{
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

- (NSString *)convertToRealMoney {
    
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self longLongValue];
    double value = m/1000.0;
    
    NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    return subStr;
}

- (NSString *)getExpressName {

    NSString *name = @"其他";
    
    NSDictionary *dic = @{@"EMS":   @"邮政EMS",
                          @"STO":   @"申通快递",
                          @"ZTO":   @"中通快递",
                          @"YTO":   @"圆通快递",
                          @"HTKY":  @"汇通快递",
                          @"SF":    @"顺丰快递",
                          @"TTKD":  @"天天快递",
                          @"ZJS":   @"宅急送",
                          
                          };
    
    if (dic[self]) {
        
        name = dic[self];
    }
    
    return name;

}

- (NSString *)getRefereeName {
    
    NSDictionary *dic = @{@"会员": @"f1",
                          @"供应商": @"supplier",
                          @"O2O商家": @"o2o",
                          @"名宿主": @"mingsu",
                          @"市/区运营商": @"operator",
                          
                          };
    
    
    return dic[self];
}

- (NSString *)getRefereeType {

    NSDictionary *dic = @{ @"f1": @"会员",
                          @"supplier": @"供应商",
                          @"o2o": @"O2O商家",
                          @"mingsu": @"名宿主",
                          @"operator": @"市/区运营商",
                          
                          };
    
    
    return dic[self];
}

@end
