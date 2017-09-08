//
//  MZBuyChips.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/6.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBuyChips.h"

@interface MZBuyChips()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISlider *slide;              //滑动条
@property (nonatomic, strong) UIButton *addButton;          //加按钮
@property (nonatomic, strong) UIButton *subtractButton;     //减按钮
@property (nonatomic, strong) UILabel *showSliderResultLabel;  //显示滑动结果
@property (nonatomic, strong) UIButton *buyButton;              //购买按钮

@property (nonatomic, assign) float  maxSlide;                  //最大值
@property (nonatomic, assign) float  minSlide;                  //最小值

@end
@implementation MZBuyChips

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) [UIColor clearColor].CGColor, (__bridge id) [UIColor blackColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    
}

- (instancetype)initWithFrame:(CGRect)frame withMax:(float)maxMoney withMin:(float)minMoney{

    if(self = [super initWithFrame:frame]){
        self.maxSlide = maxMoney;
        self.minSlide = minMoney;
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
        [tap setDelegate:self];
        
        self.slide.maximumValue = self.maxSlide;
        self.slide.minimumValue = self.minSlide;
        
        [self addSubview:self.showSliderResultLabel];
        [self addSubview:self.addButton];
        [self addSubview:self.subtractButton];
        [self addSubview:self.slide];
        [self addSubview:self.buyButton];
        
        [self.slide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.offset(kSCREEN_Width - 160);
            make.height.offset(5);
        }];
        [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.slide.mas_left).offset(-5);
            make.width.height.offset(20);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slide.mas_right).offset(5);
            make.width.height.offset(20);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.slide.mas_bottom).offset(30);
            make.width.offset(100);
            make.height.offset(40);
            make.centerX.equalTo(self.mas_centerX).offset(0);
        }];
        [self.showSliderResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.slide.mas_top).offset(-30);
            make.width.offset(100);
            make.height.offset(30);
            make.centerX.equalTo(self.mas_centerX).offset(0);
        }];
        
    }
    return self;
}

- (void)hiddenView{
    
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self);
    
}

- (void)sliderValueChanged:(id)sender{

    UISlider *slider = (UISlider *)sender;
    self.showSliderResultLabel.text = [NSString stringWithFormat:@"current：%.1f", slider.value];
}

- (void)addClickAction:(UIButton *)sender{
    if(self.slide.value>90){
        self.slide.value = self.maxSlide;
    }else{
        self.slide.value += 10;
    }
    self.showSliderResultLabel.text = [NSString stringWithFormat:@"current：%.1f", self.slide.value];
}
- (void)substractClickAction:(UIButton *)sender{
    
    if(self.slide.value<=10){
        self.slide.value = self.minSlide;
    }else{
        self.slide.value -= 10;
    }
    self.showSliderResultLabel.text = [NSString stringWithFormat:@"current：%.1f", self.slide.value];
}

- (void)buyClickAction:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(buyChipsWithMoney:)]){
        [_delegate buyChipsWithMoney:self.slide.value];
    }
}

#pragma  mark - 懒加载

- (UIButton *)addButton{

    if(!_addButton){
    
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = [UIColor greenColor];
        _addButton.layer.cornerRadius = 10.0f;
        _addButton.clipsToBounds = YES;
    }
    return _addButton;
}

- (UIButton *)subtractButton{

    if(!_subtractButton){
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtractButton setTitle:@"-" forState:UIControlStateNormal];
        _subtractButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_subtractButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(substractClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _subtractButton.backgroundColor = [UIColor greenColor];
        _subtractButton.layer.cornerRadius = 10.0f;
        _subtractButton.clipsToBounds = YES;
    }
    return _subtractButton;
}

- (UISlider *)slide{

    if(!_slide){
        _slide = [[UISlider alloc] init];
        _slide.value = 0;// 设置初始值
        _slide.continuous = YES;// 设置可连续变化
        [_slide setThumbImage:[UIImage imageNamed:@"remeberPasswordPress"] forState:UIControlStateNormal];
        [_slide setMinimumTrackImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_slide setMaximumTrackImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_slide addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    }
    return _slide;
}

- (UILabel *)showSliderResultLabel{

    if(!_showSliderResultLabel){
        _showSliderResultLabel = [[UILabel alloc] init];
        _showSliderResultLabel.text = @"current：0";
        _showSliderResultLabel.textColor = [UIColor orangeColor];
        _showSliderResultLabel.textAlignment = NSTextAlignmentCenter;
        _showSliderResultLabel.font = [UIFont systemFontOfSize:14];
    }
    return _showSliderResultLabel;
}

- (UIButton *)buyButton{

    if(!_buyButton){
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];
        _buyButton.backgroundColor = [UIColor whiteColor];
        [_buyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _buyButton;
}
@end
