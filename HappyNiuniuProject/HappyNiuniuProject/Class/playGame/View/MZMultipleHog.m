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


- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andType:(ButtonType)type{

    if(self = [super initWithFrame:frame]){
        
        multihogArray = titleArray;
        _btnType = type;
        [self initView];
    }
    return self;
}

- (void)initView{
    
    CGFloat widthScale = 20;
    CGFloat width = 60;
        for(int i=0; i<multihogArray.count; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //        btn .frame = CGRectMake((width +widthScale)*i, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            [btn setTitle:multihogArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor greenColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset((width +widthScale)*i);
                make.width.offset(width);
                make.centerY.equalTo(self.mas_centerY).offset(0);
            }];
        }
   
}
- (void)btnClickAction:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(didSelectWithIndexRow:andBtnText:andType:)]){
        
        [_delegate didSelectWithIndexRow:sender.tag andBtnText:sender.titleLabel.text andType:_btnType];
    }
}



@end
