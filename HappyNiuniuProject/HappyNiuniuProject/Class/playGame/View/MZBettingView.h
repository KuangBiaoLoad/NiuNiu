//
//  MZBettingView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/14.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MZBettingViewDelegate <NSObject>

- (void)bettingWithMoney:(int)bettingMoney;

@end

@interface MZBettingView : UIView


@property (nonatomic, assign)id<MZBettingViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withMax:(int)maxMoney withMin:(int)minMoney;
- (void)hiddenView;

@end
