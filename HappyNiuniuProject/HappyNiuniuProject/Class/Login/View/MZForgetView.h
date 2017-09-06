//
//  MZForgetView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/31.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZForgetViewDelegate <NSObject>

- (void)ForgetPasswordRequestSuccessBlock;

@end

@interface MZForgetView : UIView

@property (nonatomic, assign)id<MZForgetViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)hiddenView;

@end
