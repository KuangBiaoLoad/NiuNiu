//
//  MZAutoScrollLabel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/19.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

@class LGJAutoRunLabel;

typedef NS_ENUM(NSInteger, RunDirectionType) {
    LeftType = 0,
    RightType = 1,
};

@protocol LGJAutoRunLabelDelegate <NSObject>

@optional
- (void)operateLabel: (LGJAutoRunLabel *)autoLabel animationDidStopFinished: (BOOL)finished;

@end

@interface LGJAutoRunLabel : UIView

@property (nonatomic, weak) id <LGJAutoRunLabelDelegate> delegate;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) RunDirectionType directionType;

- (void)addContentView: (UIView *)view;
- (void)startAnimation;
- (void)stopAnimation;
