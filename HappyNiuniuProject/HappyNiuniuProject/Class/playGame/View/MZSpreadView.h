//
//  MZSpreadView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZSpreadViewDelegate <NSObject>

- (void)didSelectedWithArr:(NSArray *)imagArr;

@end

@interface MZSpreadView : UIView

@property (nonatomic, assign)id<MZSpreadViewDelegate>deleagte;
@property (nonatomic, strong) NSArray *spreadArray;             //图片数组

/*
    width:image的宽度 
    scaleWidth:image之间的间距
 */
- (void)spreadWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth;



@end
