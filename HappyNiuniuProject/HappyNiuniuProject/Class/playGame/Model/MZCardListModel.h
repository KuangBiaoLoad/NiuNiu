//
//  MZCardListModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/14.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZCardListModel : NSObject

@property (nonatomic, copy) NSString *cardNumber;   //牌数字 1-13 ,A=1.....11=J,12=Q,13=K
@property (nonatomic, copy) NSString *color;        //牌色 4：黑，3：红，2：梅，1：方


@end
