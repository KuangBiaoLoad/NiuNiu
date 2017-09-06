//
//  MZLobbySView.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/29.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZLobbySViewDelegate <NSObject>

- (void)lobbyViewDidSelectWithIndexTag:(NSInteger)indexTag;

@end

@interface MZLobbySView : UIView

@property (nonatomic, assign)id<MZLobbySViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data;

@end
