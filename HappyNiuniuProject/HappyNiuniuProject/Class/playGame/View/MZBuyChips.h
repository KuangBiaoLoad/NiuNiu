//
//  MZBuyChips.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/6.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MZBuyChipsDelegate <NSObject>

- (void)buyChipsWithMoney:(float)money;

@end

@interface MZBuyChips : UIView

@property (nonatomic, assign)id<MZBuyChipsDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withMax:(float)maxMoney withMin:(float)minMoney;
- (void)hiddenView;

@end
