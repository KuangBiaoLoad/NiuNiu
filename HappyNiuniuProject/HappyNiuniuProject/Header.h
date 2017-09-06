//
//  Header.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import "KDAlertView.h"
#import "Masonry.h"
#import <YYCategories/YYCategories.h>
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import <YYModel/YYModel.h>
#import "UIImage+Color.h"
#import "KDCheckTxt.h"
#import "MZlocalizableContoller.h"
#define ScreenScale ([[UIScreen mainScreen] scale])
#define iPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiOS7       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define kiOS8       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
// App Name
#define AppDisplayName      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define currentVersion      [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSCREEN_Width       ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)


#define kNavBarTintColor UIColorFromRGB(42,42,42) //导航栏颜色
#define kTabBarTintColor UIColorFromRGB(253, 253, 253)
#define COLOR_BG [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]

#define GDLocalizedString(key) [[MZlocalizableContoller bundle] localizedStringForKey:(key) value:@"" table:nil]
#endif /* Header_h */
