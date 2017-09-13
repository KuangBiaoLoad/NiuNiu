//
//  MZGameRuleView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/11.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZGameRuleModel.h"
@interface MZGameRuleView : UIView


@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, strong) MZGameRuleModel *model;

@end
