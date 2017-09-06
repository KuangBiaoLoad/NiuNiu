//
//  KBSMSBtn.h
//  ylShop
//
//  Created by Apple_KB on 2017/5/4.
//  Copyright © 2017年 eeepay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBSMSBtn : UIButton

/** 计时器 **/
@property(nonatomic, strong) NSTimer *SMSTimer;
/** 总时间 **/
@property(nonatomic, assign) int  totalTime;
/** 按钮上的文字 **/
@property(nonatomic, strong) NSString *titleStr;
/** 点击之后按钮上的文字 **/
@property(nonatomic, strong) NSString *touchStr;


- (instancetype)init;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)reloadTimer;
- (void)enableTimer;

@end
