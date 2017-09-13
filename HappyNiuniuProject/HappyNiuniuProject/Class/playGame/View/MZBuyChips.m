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

@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *minMoneyLabel;
@property (nonatomic, strong) UILabel *maxMoneyLabel;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *suggestLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *bacImageView;
@property (nonatomic, strong) UIView *goldView;
@property (nonatomic, strong) UIImageView *goldBacImageView;
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
        [self addSubview:self.bacImageView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
//        [self addGestureRecognizer:tap];
//        [tap setDelegate:self];
        
        self.slide.maximumValue = self.maxSlide;
        self.slide.minimumValue = self.minSlide;
        [self addSubview:self.addButton];
        [self addSubview:self.subtractButton];
        [self addSubview:self.slide];
        [self addSubview:self.buyButton];
        [self addSubview:self.minLabel];
        [self addSubview:self.maxLabel];
        [self addSubview:self.totalLabel];
        [self addSubview:self.suggestLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.minMoneyLabel];
        [self addSubview:self.maxMoneyLabel];
        [self addSubview:self.goldView];
        [self.slide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.offset(269.5/568 *kSCREEN_Width);
            make.height.offset(5/269.5 * self.slide.width);
        }];
        [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.slide.mas_left).offset(-25);
            make.width.height.offset(30/568.0 *kSCREEN_Width);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slide.mas_right).offset(25);
            make.width.height.offset(30/568.0 *kSCREEN_Width);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        
        [self.goldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.slide.mas_bottom).offset(15);
            make.centerX.equalTo(self.slide.mas_left).offset(15);
            make.width.offset(56);
            make.height.offset(29);
        }];
        [self.goldBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.width.offset(56);
            make.height.offset(29);
        }];
        [self.showSliderResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.goldView.mas_centerX).offset(0);
            make.bottom.equalTo(self.goldBacImageView.mas_bottom).offset(-6);
        }];
        [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slide.mas_left).offset(0);
            make.bottom.equalTo(self.slide.mas_top).offset(-20);
        }];
        [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.slide.mas_right).offset(0);
            make.bottom.equalTo(self.slide.mas_top).offset(-20);
        }];
        [self.minMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.minLabel.mas_top).offset(0);
            make.left.equalTo(self.minLabel.mas_left).offset(0);
        }];
        [self.maxMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.maxLabel.mas_top).offset(0);
            make.left.equalTo(self.maxLabel.mas_left).offset(0);
        }];
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.slide.mas_bottom).offset(50);
            make.centerX.equalTo(self.mas_centerX).offset(0);
        }];
        [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.totalLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.offset(196/2.0);
            make.height.offset(82/2.0);
        }];
        [self.suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buyButton.mas_bottom).offset(15);
            make.centerX.equalTo(self.mas_centerX).offset(0);
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(27/568.0 *kSCREEN_Width);
            make.right.equalTo(self.mas_right).offset(-18);
            make.top.offset(16);
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
    [self caculateSize];
}

- (void)addClickAction:(UIButton *)sender{
    if(self.slide.value>90){
        self.slide.value = self.maxSlide;
    }else{
        self.slide.value += 10;
    }
    [self caculateSize];
}
- (void)substractClickAction:(UIButton *)sender{
    
    if(self.slide.value<=10){
        self.slide.value = self.minSlide;
    }else{
        self.slide.value -= 10;
    }
    [self caculateSize];
}

- (void)caculateSize{
    self.showSliderResultLabel.text = [NSString stringWithFormat:@"$%.1f", self.slide.value];
    //104 * 106
    
    CGRect rect = self.goldView.frame;
    rect.origin.x = self.slide.frame.origin.x + (self.slide.frame.size.width - 3.53)/(self.maxSlide - self.minSlide)*self.slide.value - 34/(self.maxSlide - self.minSlide)*self.slide.value - rect.size.width/2 + 34/2 +2;
    self.goldView.frame = rect;
    
//    self.goldView.frame = CGRectMake(self.slide.frame.origin.x + self.slide.value/(self.maxSlide - self.minSlide) * self.slide.frame.size.width, self.goldView.frame.origin.y, self.goldView.frame.size.width, self.goldView.frame.size.height);
//    self.goldView.centerX = self.slide.frame.origin.x + self.slide.value/(self.maxSlide - self.minSlide) * self.slide.frame.size.width;
}

- (void)buyClickAction:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(buyChipsWithMoney:)]){
        [_delegate buyChipsWithMoney:self.slide.value];
    }
}

#pragma  mark - 懒加载

- (UIImageView *)bacImageView{

    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bacImageView.image = [UIImage imageNamed:@"shadeBlackBac"];
    }
    return _bacImageView;
}

- (UIButton *)addButton{

    if(!_addButton){
    
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"shadeAddBtn"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.cornerRadius = 10.0f;
        _addButton.clipsToBounds = YES;
    }
    return _addButton;
}

- (UIButton *)subtractButton{

    if(!_subtractButton){
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtractButton setBackgroundImage:[UIImage imageNamed:@"shadeReduceBtn"] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(substractClickAction:) forControlEvents:UIControlEventTouchUpInside];
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
        [_slide setThumbImage:[UIImage imageNamed:@"shadeGoldIcon"] forState:UIControlStateNormal];
        [_slide setMinimumTrackImage:[UIImage imageNamed:@"shadeSlideGroove"] forState:UIControlStateNormal];
        [_slide setMaximumTrackImage:[UIImage imageNamed:@"shadeSlideGroove"] forState:UIControlStateNormal];
        [_slide addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    }
    return _slide;
}

- (UILabel *)showSliderResultLabel{

    if(!_showSliderResultLabel){
        _showSliderResultLabel = [[UILabel alloc] init];
        _showSliderResultLabel.text = @"$10";
        _showSliderResultLabel.textColor = [UIColor whiteColor];
        _showSliderResultLabel.textAlignment = NSTextAlignmentCenter;
        _showSliderResultLabel.font = [UIFont systemFontOfSize:12];
    }
    return _showSliderResultLabel;
}

- (UIButton *)buyButton{

    if(!_buyButton){
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"买入游戏" forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"FFF9F2"] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

- (UILabel *)minLabel{

    if(!_minLabel){
        _minLabel = [[UILabel alloc] init];
        _minLabel.font = [UIFont systemFontOfSize:9];
        _minLabel.textColor = [UIColor colorWithHexString:@"FFE012"];
        _minLabel.text = @"最小";
    }
    return _minLabel;
}

-(UILabel *)maxLabel{

    if(!_maxLabel){
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.font = [UIFont systemFontOfSize:9];
        _maxLabel.textColor = [UIColor colorWithHexString:@"FFE012"];
        _maxLabel.text = @"最大";
    }
    return _maxLabel;
}

- (UILabel *)totalLabel{

    if(!_totalLabel){
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:12];
        _totalLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _totalLabel.text = @"您的账户余额：12，345";
    }
    return _totalLabel;
}

- (UILabel *)suggestLabel{

    if(!_suggestLabel){
        _suggestLabel = [[UILabel alloc] init];
        _suggestLabel.font = [UIFont systemFontOfSize:9];
        _suggestLabel.textColor = [UIColor colorWithHexString:@"AC936C"];
        _suggestLabel.text = @"注意：您一但就坐，就会被收取盲注";//172 147 108
    }
    return _suggestLabel;
}

- (UIButton *)closeButton{

    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage: [UIImage imageNamed:@"shadeClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)minMoneyLabel{

    if(!_minMoneyLabel){
        _minMoneyLabel = [[UILabel alloc] init];
        _minMoneyLabel.font = [UIFont systemFontOfSize:12];
        _minMoneyLabel.text = @"$ 50";
        _minMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _minMoneyLabel;
}

- (UILabel *)maxMoneyLabel{

    if(!_maxMoneyLabel){
        _maxMoneyLabel = [[UILabel alloc] init];
        _maxMoneyLabel.font = [UIFont systemFontOfSize:12];
        _maxMoneyLabel.text = @"$ 2000";
        _maxMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _maxMoneyLabel;
}

- (UIView *)goldView{

    if(!_goldView){
        _goldView = [[UIView alloc] init];
        [_goldView addSubview:self.goldBacImageView];
        [_goldView addSubview:self.showSliderResultLabel];
    }
    return _goldView;
}

- (UIImageView *)goldBacImageView{

    if(!_goldBacImageView){
        _goldBacImageView = [[UIImageView alloc] init];
        _goldBacImageView.image = [UIImage imageNamed:@"shadeGoldSuggestGroove"];
    }
    return _goldBacImageView;
}


@end
