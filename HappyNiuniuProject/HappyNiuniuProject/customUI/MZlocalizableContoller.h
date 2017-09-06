//
//  MZlocalizableContoller.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/5.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

#define RDLanguageKey @"userLanguage"

#define RDCHINESE @"zh-Hans"

#define RDENGLISH @"en"

#define RDNotificationLanguageChanged @"rdLanguageChanged"

#define RDLocalizedString(key)  [[MZlocalizableContoller bundle] localizedStringForKey:(key) value:@"" table:nil]


@interface MZlocalizableContoller : NSObject

/**
 *  获取当前资源文件
 */
+ (NSBundle *)bundle;
/**
 *  初始化语言文件
 */
+ (void)initUserLanguage;
/**
 *  获取应用当前语言
 */
+ (NSString *)userLanguage;
/**
 *  设置当前语言
 */
+ (void)setUserlanguage:(NSString *)language;



@end
