//
//  MZCountdownLabel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZCountdownLabelDelegate <NSObject>

- (void)countdowmEnd;

@end

@interface MZCountdownLabel : UILabel

@property (nonatomic) NSTimer *SMSTimer;
@property (nonatomic) int totalTime;

@property (nonatomic, assign)id<MZCountdownLabelDelegate>delegate;

- (void)enableTimer;

- (void)reloadTimer;
@end
