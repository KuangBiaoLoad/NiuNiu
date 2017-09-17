//
//  MZSpreadView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSpreadView : UIView
@property (nonatomic, strong) NSArray *spreadArray;             //图片数组
@property (nonatomic, strong)UIImageView *showNiuImageView;
@property (nonatomic, assign) CGFloat updateImageWdith;
@property (nonatomic, copy) NSString *cardNorImage;
@property (nonatomic, copy) NSString *shapeStr;
/*
    width:image的宽度 
    scaleWidth:image之间的间距
 */
- (void)spreadWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth;



@end
