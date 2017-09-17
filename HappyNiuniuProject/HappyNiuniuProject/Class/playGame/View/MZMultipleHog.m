//
//  MZMultipleHog.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZMultipleHog.h"

@implementation MZMultipleHog{

    NSArray *multihogArray;
}


- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray{

    if(self = [super initWithFrame:frame]){
        
        multihogArray = titleArray;
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat width = (self.frame.size.width - (multihogArray.count - 1)*kmultihogviewScaleWidth)/multihogArray.count;
        for(int i=0; i<multihogArray.count; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        btn .frame = CGRectMake((width +widthScale)*i, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            [btn setTitle:multihogArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"check_boomPourImage"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset((width +kmultihogviewScaleWidth)*i);
                make.width.offset(width);
                make.centerY.equalTo(self.mas_centerY).offset(0);
            }];
        }
   
}
- (void)btnClickAction:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(didSelectWithBtnText:)]){
        
        [_delegate didSelectWithBtnText:sender.titleLabel.text];
    }
}

- (void)setImageStr:(NSString *)imageStr{

    _imageStr = imageStr;
    for(int i=0; i<multihogArray.count; i++){
    
        UIButton *btn = (UIButton *)[self viewWithTag:i+1];
        [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
}

@end
