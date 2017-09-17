//
//  MZBuyChips.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/6.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MZBuyChipsDelegate <NSObject>

- (void)buyChipsWithMoney:(int)money;

@end

@interface MZBuyChips : UIView

@property (nonatomic, assign)id<MZBuyChipsDelegate>delegate;

@property (nonatomic, assign) int totalMoney;
@property(nonatomic, assign) int maxMoney;
@property (nonatomic, assign) int minMoney;
- (void)hiddenView;

@end
