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
    bottomPourType,
    multipleType,
} ButtonType;
@protocol MZMultipleHogDelegate <NSObject>

- (void)didSelectWithBtnText:(NSString *)btnText;

@end
@interface MZMultipleHog : UIView

@property (nonatomic, assign)id<MZMultipleHogDelegate>delegate;

@property (nonatomic, strong) NSString *imageStr;


- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;

//- (void)hiddenView;

@end
