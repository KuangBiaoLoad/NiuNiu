//
//  MZcalculateNiuView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/31.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZcalculateNiuView.h"

@implementation MZcalculateNiuView

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
    
    CGFloat widthScale = 20;
    CGFloat width = 60;
    for(int i=0; i<4; i++){
        UILabel *cardLabel = [[UILabel alloc] init];
        cardLabel.tag = 10 + i;
        cardLabel.textColor = [UIColor whiteColor];
        cardLabel.font = [UIFont systemFontOfSize:14];
        cardLabel.textAlignment = NSTextAlignmentCenter;
        cardLabel.backgroundColor = [UIColor redColor];
        [self addSubview:cardLabel];
        [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset((width +widthScale)*i);
            make.width.offset(width);
//            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
        if(i<3){
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor greenColor];
            label.textAlignment = NSTextAlignmentCenter;
            if(i==2){
            label.text = @"=";
            }else{
            label.text = @"+";
            }
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset((width +widthScale)*i + width);
                make.width.offset(widthScale);
                make.centerY.equalTo(self.mas_centerY).offset(0);
            }];
        }
        
    }
}


- (void)didSelectedWithArr:(NSArray *)imagArr{

    NSInteger totalCount = 0 ;
    for(int i=0;i<3;i++){
        UILabel *imageLabel = [self viewWithTag:10+i];
        NSString *str = [imagArr[i] substringFromIndex:1];
        if([str isEqualToString:@"J"] ||[str isEqualToString:@"Q"] ||[str isEqualToString:@"K"]){
            imageLabel.text = @"10";
            totalCount +=10;
        }else{
            imageLabel.text = str;
            totalCount += str.integerValue;
        }
    }
    UILabel *totalLabel = [self viewWithTag:13];
    totalLabel.text = [NSString stringWithFormat:@"%ld",totalCount];
    
    NSLog(@"进入了---------阿日让绒%@",imagArr);
}

@end
