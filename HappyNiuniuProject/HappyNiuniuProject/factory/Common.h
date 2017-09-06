//
//  Common.h
//  SuperCode
//
//  Created by 斌 on 2016/9/26.
//  Copyright © 2016年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Common : NSObject
//其他常用
+ (void)setData:(id)valueData key:(NSString *)keyString;
+ (id)getData:(NSString *)pathString;

+ (NSString *)SET_SERVER_ADDR_HTTP:(NSString *)string TYPE:(int)typeNum;

+ (NSString *)encodeMD5:(NSString *)inPutText;

+ (NSString *)cardStar:(NSString *)string;

+ (NSString *)mobileStar:(NSString *)string;

+ (void)showAlertInViewCtrl:(UIViewController *)viewCtrl message:(NSString *)msg;

+ (UIViewController *)getCurrentVC;

+ (void)deleteFileWithTag:(int)tag;

+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp;
//获取系统当前时间
+ (NSString *)getSystemCurrentTime;
//计算字符串高度
+ (CGSize )calculateHeightForStr:(NSString *)str width:(CGFloat)width font:(CGFloat)fontSize;
@end
