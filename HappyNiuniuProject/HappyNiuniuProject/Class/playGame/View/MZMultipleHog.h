//
//  MZMultipleHog.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZSpreadView.h"

typedef enum : NSUInteger {
    normalType,
    prepareType,
    hogType,
    multipleType,
} ButtonType;
@protocol MZMultipleHogDelegate <NSObject>

- (void)didSelectWithIndexRow:(NSInteger)indexRow andBtnText:(NSString *)btnText andType:(ButtonType)type;

@end
@interface MZMultipleHog : UIView

@property (nonatomic, assign)id<MZMultipleHogDelegate>delegate;

@property (nonatomic, assign) ButtonType btnType;



- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andType:(ButtonType)type;

//- (void)hiddenView;

@end
