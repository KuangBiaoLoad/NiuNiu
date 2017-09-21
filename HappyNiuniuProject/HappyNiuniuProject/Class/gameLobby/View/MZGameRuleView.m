//
//  MZGameRuleView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/11.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZGameRuleView.h"

@interface MZGameRuleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bacImageView;    //背景图
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UILabel *contentLabel;        //文本
@property (nonatomic, strong) UIButton *closeButton;        //取消按钮
@property (nonatomic, strong) UIScrollView *ruleScrollView;  //滚动视图
@end

@implementation MZGameRuleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.bacImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.ruleScrollView];
    [self.ruleScrollView addSubview:self.contentLabel];
    [self addSubview:self.closeButton];
    
    [self.bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.width.offset(self.frame.size.width * 0.6);
        make.height.equalTo(self.bacImageView.mas_width).multipliedBy(221/331.0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.bacImageView.mas_top).offset(10);
    }];
    [self.ruleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bacImageView.mas_left).offset(10);
        make.right.equalTo(self.bacImageView.mas_right).offset(-10);
        make.bottom.equalTo(self.bacImageView.mas_bottom).offset(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ruleScrollView.mas_left).offset(5);
        make.width.equalTo(self.ruleScrollView.mas_width).offset(-10);
        make.top.equalTo(self.ruleScrollView.mas_top).offset(5);
        make.bottom.equalTo(self.ruleScrollView.mas_bottom).offset(-10);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bacImageView.mas_top).offset(6);
        make.right.equalTo(self.bacImageView.mas_right).offset(-8);
        make.width.height.offset(21/568.0 *kSCREEN_Width);
    }];
}

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

- (void)hiddenView{
    
    [self removeFromSuperview];
}

- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.contentLabel.text = contentStr;
    CGSize contentSize =  [contentStr boundingRectWithSize:CGSizeMake(self.frame.size.width * 0.6 - 100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
    self.ruleScrollView.contentSize = CGSizeMake(0, contentSize.height + 15);
}

- (void)setModel:(MZGameRuleModel *)model{
    
    _model = model;
    if([[MZlocalizableContoller userLanguage] isEqualToString:RDCHINESE]){
        self.contentLabel.text = _model.rulecn;
        CGSize contentSize =  [_model.rulecn boundingRectWithSize:CGSizeMake(self.frame.size.width * 0.6 - 100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
        self.ruleScrollView.contentSize = CGSizeMake(0, contentSize.height + 15);
    }else{
        self.contentLabel.text = _model.ruleen;
        CGSize contentSize =  [_model.ruleen boundingRectWithSize:CGSizeMake(self.frame.size.width * 0.6 - 100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;
        self.ruleScrollView.contentSize = CGSizeMake(0, contentSize.height + 15);
    }
}

#pragma  mark - 懒加载
- (UIImageView *)bacImageView{
    
    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.image = [UIImage imageNamed:@"loggyAlertBacImage"];
    }
    return _bacImageView;
}

- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"游戏规则";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"7C5828"];
        _contentLabel.font = [UIFont systemFontOfSize:9];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)closeButton{
    
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"shadeClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIScrollView *)ruleScrollView{
    
    if(!_ruleScrollView){
        _ruleScrollView = [[UIScrollView alloc] init];
        _ruleScrollView.delegate = self;
        _ruleScrollView.backgroundColor = [UIColor clearColor];
        _ruleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _ruleScrollView;
}

@end
