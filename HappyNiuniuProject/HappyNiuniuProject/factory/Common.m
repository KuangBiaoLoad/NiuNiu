//
//  Common.m
//  SuperCode
//
//  Created by 斌 on 2016/9/26.
//  Copyright © 2016年 斌. All rights reserved.
//

#import "Common.h"
#import "commoncrypto/commondigest.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
@implementation Common

static NSString *SERVER_ADDR_STRING = @"https://api-qr.yfbpay.cn/qr/";
static NSMutableDictionary *allData;
+ (void)setData:(id)valueData key:(NSString *)keyString {
    
    if ([keyString isEqualToString:@"clean"]) {
        allData=[[NSMutableDictionary alloc]init];
        return ;
    }
    
    if (!allData) {
        allData=[[NSMutableDictionary alloc]init];
        
    }
    
    if ([allData objectForKey:keyString]) {
        [allData removeObjectForKey:keyString];
    }
    
    [allData setValue:valueData forKey:keyString];
    
}

+ (id)getData:(NSString *)pathString {
    
    NSArray *tempAr = [pathString componentsSeparatedByString:@"/"];
    
    NSDictionary *tempDict = allData;
    
    for (int i=0;i < tempAr.count;i++) {
        
        tempDict = [tempDict objectForKey:[tempAr objectAtIndex:i]];
        
    }
    
    if (!tempDict) {
        return @"";
    }
    
    return tempDict;
}

+ (NSString *)SET_SERVER_ADDR_HTTP:(NSString *)string TYPE:(int)typeNum {
    if ([string isEqualToString:@""]){
        if (typeNum == 1) {
            return SERVER_ADDR_STRING;
        }
    }
    
    if (typeNum == 1) {
        SERVER_ADDR_STRING = string;
    }
    
    return nil;
}


+ (NSString *)encodeMD5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}



+ (NSString *)cardStar:(NSString *)string{
    
    @try {
        NSString *cardStarString;
        cardStarString = [string stringByReplacingCharactersInRange:NSMakeRange(6, string.length-10) withString:@"****"];
        return cardStarString;
    }
    @catch (NSException *exception) {
        NSLog(@"提供的卡号错误");
        return string;
    }
    
}

+ (NSString *)mobileStar:(NSString *)string{
    
    @try {
        NSString *cardStarString;
        cardStarString = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return cardStarString;
    }
    @catch (NSException *exception) {
        NSLog(@"提供的手机号错误");
        return string;
    }
    
}

+ (void)showAlertInViewCtrl:(UIViewController *)viewCtrl message:(NSString *)msg{
    
    if (kiOS8) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [viewCtrl presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


+ (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow * tmpWin in windows)
    {
        if (tmpWin.windowLevel == UIWindowLevelNormal)
        {
            window = tmpWin;
            break;
        }
    }
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        
        result = window.rootViewController;
        if (result.presentedViewController) {
            result = result.presentedViewController;
        }
    }
    return result;
}


+ (void)deleteFileWithTag:(int)tag {
    
    NSString *uniquePath = [@"file" stringByAppendingFormat:@"%d.png",tag];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *imgPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:uniquePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (!blHave) {
        NSLog(@"no  have");
        return;
    }else {
        NSLog(@"have");
        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
    
}

+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp {
    double publishLong = [timestamp doubleValue]/1000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+8"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong];
    NSString *publishString = [formatter stringFromDate:publishDate];
    
    return publishString;
}

//获取当前时间（毫秒计）
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

+ (NSString *)getSystemCurrentTime{
    NSDate * senddate=[NSDate date];
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSString * nsDateString= [NSString stringWithFormat:@"%ld年%ld月",year,month];
    return nsDateString;
}

+ (CGSize )calculateHeightForStr:(NSString *)str width:(CGFloat)width font:(CGFloat)fontSize {

    CGSize size = CGSizeMake(width,MAXFLOAT); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return labelsize;
}
#pragma mark - 保存和读取UUID
+(void)saveUUIDToKeyChain{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithAccount:@"Identfier" service:@"AppName" accessGroup:nil];
    NSString *string = [keychainItem objectForKey: (__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string){
        [keychainItem setObject:[self getUUIDString] forKey:(__bridge id)kSecAttrGeneric];
    }
}

+(NSString *)readUUIDFromKeyChain{
    KeychainItemWrapper *keychainItemm = [[KeychainItemWrapper alloc] initWithAccount:@"Identfier" service:@"AppName" accessGroup:nil];
    NSString *UUID = [keychainItemm objectForKey: (__bridge id)kSecAttrGeneric];
    return UUID;
}

+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}



@end
