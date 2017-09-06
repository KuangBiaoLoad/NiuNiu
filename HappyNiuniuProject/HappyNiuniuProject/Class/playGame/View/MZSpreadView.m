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
    
    self.backgroundColor = [UIColor lightGrayColor];
    mutableArray = [[NSMutableArray alloc] init];
}

- (void)spreadWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth{

    for(int i =0; i<5; i++){
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor blueColor];
        [btn addTarget: self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.left.offset((scaleWidth + width)*i);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

- (void)btnClickAction:(UIButton *)sender{
    
    [mutableArray addObject:_spreadArray[sender.tag - 100]];
    [mutableArray addObject:_spreadArray[sender.tag - 100]];
    [mutableArray addObject:_spreadArray[sender.tag - 100]];
    
    if( [_deleagte respondsToSelector:@selector(didSelectedWithArr:)]){
    
        [_deleagte didSelectedWithArr:mutableArray];
    }
    
}


- (void)setSpreadArray:(NSArray *)spreadArray{

    _spreadArray = spreadArray;
    for(int i=0; i<spreadArray.count; i++){
        UIButton *btnImage = (UIButton *)[self viewWithTag:100+i];
        [btnImage setBackgroundImage:[UIImage imageNamed:spreadArray[i]] forState:UIControlStateNormal];
    }
}

@end
