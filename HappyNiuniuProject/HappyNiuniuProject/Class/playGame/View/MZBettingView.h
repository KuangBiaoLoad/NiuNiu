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
@property(nonatomic, assign) int maxMoney;
@property (nonatomic, assign) int minMoney;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)hiddenView;

@end
