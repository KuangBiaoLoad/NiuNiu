//
//  MZOverlapView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZOverlapView.h"

@implementation MZOverlapView
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
    self.showNiuImageView = [[UIImageView alloc] init];
    self.showNiuImageView.image = [UIImage imageNamed:@"check_niu4"];
}

- (void)overlapWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth{

    for(int i = 0; i<5; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 10+i;
        imageView.image = [UIImage imageNamed:@"backCard"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(scaleWidth*i);
            make.width.offset(width);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    [self addSubview:self.showNiuImageView];
    [self.showNiuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(5);
        make.height.equalTo(self.mas_height);
        
    }];
}

- (void)setOverlapImageArray:(NSArray *)overlapImageArray{

    _overlapImageArray = overlapImageArray;
    
    //黑桃S 红心H 方块D  梅花C
    for(int i=0; i<overlapImageArray.count; i++){
     UIImageView *imageView = (UIImageView *)[self viewWithTag:10+i];
        imageView.image = [UIImage imageNamed:overlapImageArray[i]];
    }
   
}


@end
