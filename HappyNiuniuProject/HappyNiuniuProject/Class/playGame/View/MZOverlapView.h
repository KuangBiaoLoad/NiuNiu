//
//  MZOverlapView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZOverlapView : UIView

@property (nonatomic, strong) NSArray *overlapImageArray;  //闲家牌数组
@property (nonatomic, strong)UIImageView *showNiuImageView;
/*
    width:image的宽度
    scaleWidth:间距
 */
- (void)overlapWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth;

@end
