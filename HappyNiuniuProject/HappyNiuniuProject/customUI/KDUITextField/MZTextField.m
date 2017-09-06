//
//  MZTextField.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/4.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZTextField.h"

@implementation MZTextField

- (instancetype)init{

    if(self = [super init]){
    
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
    
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    [[self placeholder] drawInRect:CGRectMake(0, (self.height - 12)/2.0, self.width , self.height) withAttributes:@{
                                                                                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                NSFontAttributeName:[UIFont systemFontOfSize:10]
                                                                                                }];
}

@end
