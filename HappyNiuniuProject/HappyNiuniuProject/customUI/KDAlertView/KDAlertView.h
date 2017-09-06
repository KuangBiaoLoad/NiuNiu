//
//  KDAlertView.h
//  KDTools
//
//  Created by 斌 on 15/11/19.
//  Copyright © 2015年 斌. All rights reserved.


#import <UIKit/UIKit.h>

typedef enum
{
    KDAlertViewShowLocDefault = 0, //默认居中
    KDAlertViewShowLocTop,  //顶部
    KDAlertViewShowLocBottom, //底部
}KDAlertViewShowLoc;


@interface KDAlertView : UIView

+ (void)showAlertInViewCtrl:(UIViewController *)viewCtrl title:(NSString *)title message:(NSString *)message buttonItems:(NSArray *)btnItems;

+ (void)alertWithMessage:(NSString *)message;
+ (void)alertWithMessage:(NSString *)message location:(KDAlertViewShowLoc)location;

- (void)alertWithMessage:(NSString *)message inView:(UIView *)view;





@end
