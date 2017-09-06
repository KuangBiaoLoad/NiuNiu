//
//  MZLabel.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/4.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZLabel.h"

@implementation MZLabel

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

//- (void)drawTextInRect:(CGRect)rect {
//    
//    CGSize shadowOffset = self.shadowOffset;
//    UIColor *textColor = self.textColor;
//    
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(c, 0.5);
//    CGContextSetLineJoin(c, kCGLineJoinRound);
//    
//    CGContextSetTextDrawingMode(c, kCGTextStroke);
////    self.textColor = [UIColor whiteColor];
//    [super drawTextInRect:rect];
//    
//    CGContextSetTextDrawingMode(c, kCGTextFill);
//    self.textColor = textColor;
//    self.shadowOffset = CGSizeMake(0, 0);
//    [super drawTextInRect:rect];
//    
//    self.shadowOffset = shadowOffset;
//    
//}
- (void)drawTextInRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 0.2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
//    self.textColor = self.strokeColor;
    [super drawTextInRect:rect];
//    self.textColor = self.fillColor;
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}
@end
