//
//  KDAnimation.m
//  KDTools
//
//  Created by 斌 on 15/11/21.
//  Copyright © 2015年 斌. All rights reserved.
//

#import "KDAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation KDAnimation


+ (void)shakeAnimationWithView:(UIView *)view{

    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, 0.1, 0, 0, 1)];
    
    [view.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
    
}

+ (void)stopAnimationWithView:(UIView *)view{

    [view.layer removeAnimationForKey:@"shakeAnimation"];
}


+ (void)showAnimationWithView:(UIView *)view{

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [view.layer addAnimation:animation forKey:nil];

}

@end
