//
//  KDAnimation.h
//  KDTools
//
//  Created by 斌 on 15/11/21.
//  Copyright © 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KDAnimation : NSObject

+ (void)shakeAnimationWithView:(UIView *)view;
+ (void)stopAnimationWithView:(UIView *)view;

+ (void)showAnimationWithView:(UIView *)view;


@end
