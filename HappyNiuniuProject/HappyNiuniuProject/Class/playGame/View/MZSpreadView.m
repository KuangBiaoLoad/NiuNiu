//
//  MZSpreadView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZSpreadView.h"

@implementation MZSpreadView{

    NSMutableArray *mutableArray;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}
- (id)init{
    
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
    
}
- (void)initView{
    mutableArray = [[NSMutableArray alloc] init];
    self.showNiuImageView = [[UIImageView alloc] init];
    self.showNiuImageView.tag = 1000;
    self.showNiuImageView.image = [UIImage imageNamed:@"check_noteNiu"];
}

- (void)spreadWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth{

    for(int i =0; i<5; i++){
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        [btn setBackgroundImage: [UIImage imageNamed:@"backCard"] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.left.offset((scaleWidth + width)*i);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    [self addSubview:self.showNiuImageView];
    [self.showNiuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(self.mas_height);
        
    }];
}


- (void)setSpreadArray:(NSArray *)spreadArray{

    _spreadArray = spreadArray;
    for(int i=0; i<spreadArray.count; i++){
        UIButton *btnImage = (UIButton *)[self viewWithTag:100+i];
        [btnImage setBackgroundImage:[UIImage imageNamed:spreadArray[i]] forState:UIControlStateNormal];
    }
}
- (void)setUpdateImageWdith:(CGFloat)updateImageWdith{
    _updateImageWdith = updateImageWdith;
    for(int i=0;i<5;i++){
    
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(updateImageWdith);
            make.left.offset((updateImageWdith + 2)*i);
        }];
    }
    UIImageView *niuImage = (UIImageView *)[self viewWithTag:1000];
    [niuImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(updateImageWdith * 3.5 + 4);
        
    }];
}

@end
