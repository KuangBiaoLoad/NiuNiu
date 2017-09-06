//
//  Common.m
//  SuperCode
//
//  Created by 斌 on 2016/9/26.
//  Copyright © 2016年 斌. All rights reserved.
//

#import "Common.h"
#import "commoncrypto/commondigest.h"

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

@end
