//
//  MZBackView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/15.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZBackViewDelegate <NSObject>

- (void)clickButtonWithTag:(int)btnTag;

@end

@interface MZBackView : UIView

@property (nonatomic, assign)id<MZBackViewDelegate>deleagte;
@property (nonatomic, strong) UIButton *gotUpbtn;           //起身
- (void)hiddenView;

@end
