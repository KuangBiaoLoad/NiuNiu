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
    
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)overlapWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth{

    for(int i = 0; i<5; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 10+i;
        imageView.image = [UIImage imageNamed:@""];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(scaleWidth*i);
            make.width.offset(width);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
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
