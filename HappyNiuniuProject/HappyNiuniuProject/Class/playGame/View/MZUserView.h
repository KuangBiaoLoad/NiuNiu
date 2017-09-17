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


@protocol MZUserViewDelegate <NSObject>

- (void)headImageBtnClick;

@end

@interface MZUserView : UIView

- (void)userDirection:(directionType)type;

//图片的圆角半径
- (void)createUserCoradius:(CGFloat)coradiusStr;

@property (nonatomic, assign) BOOL whetherAnyone;        //位置是否有人
@property (nonatomic, strong) NSDictionary *userDict;   //user字典
@property (nonatomic, assign) BOOL isbanker;     //是否是庄家
@property (nonatomic, assign)id<MZUserViewDelegate>delegate;
@end
