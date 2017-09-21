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
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}
//- (CGRect)editingRectForBounds:(CGRect)bounds{
//     return CGRectInset( bounds , 1 , 0 );
//}

- (void)drawRect:(CGRect)rect {//rect代表该自定义textField的frame/rect
    [super drawRect:rect]; //调用父类UITextField的drawRect方法，将自定义尺寸传进去。必须调用父类
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
}

//- (void)drawPlaceholderInRect:(CGRect)rect{
//    if(kiOS11){
//
////        [[self placeholder] drawAtPoint:CGPointMake(0, (self.height - self.font.pointSize)/2.0) withAttributes:@{
////                                                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
////                                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:10]
////                                                                                                                 }];
////        [[self placeholder] drawInRect:CGRectMake(0, (self.height - self.font.pointSize)/2.0, self.width , self.height) withAttributes:@{
////                                                                                                                                              NSForegroundColorAttributeName:[UIColor whiteColor],
////                                                                                                                                              NSFontAttributeName:[UIFont systemFontOfSize:10]
////                                                                                                                                              }];
////
//
//
//        [[self placeholder] addAttribute:NSForegroundColorAttributeName
//                            value:[UIColor redColor]
//                            range:NSMakeRange(0, self.width)];
//        [[self placeholder] addAttribute:NSFontAttributeName
//                            value:[UIFont boldSystemFontOfSize:10]
//                            range:NSMakeRange(0, self.width)];
//
//
//    }else{
//        [[self placeholder] drawInRect:CGRectMake(0, (self.height - self.font.pointSize)/2.0, self.width , self.height) withAttributes:@{
//                                                                                                                                              NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                                                                                                              NSFontAttributeName:[UIFont systemFontOfSize:10]
//                                                                                                                                              }];
//
//    }
//
//}

@end
