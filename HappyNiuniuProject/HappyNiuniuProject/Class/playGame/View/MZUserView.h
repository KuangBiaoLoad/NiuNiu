//
//  MZUserView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    horizontalDirectionType,
    verticalDirectionType,
} directionType;

@interface MZUserView : UIView

- (void)userDirection:(directionType)type withImageUrl:(NSString *)imageStr withUserNameStr:(NSString *)userStr withGoldStr:(NSString *)goldStr;

//图片的圆角半径
- (void)createUserCoradius:(CGFloat)coradiusStr;

@property (nonatomic, strong) NSDictionary *userDict;   //user字典
@property (nonatomic, copy) NSString *bankHeaderImageStr;//庄家背景光环

@end
