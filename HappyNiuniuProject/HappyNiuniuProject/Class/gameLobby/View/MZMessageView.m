//
//  MZMessageView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/11.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZMessageView.h"
#import "MZMessageCell.h"
@interface MZMessageView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *bacImageView;    //背景图
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) UIButton *closeButton;        //取消按钮
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MZMessageView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bacImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageTableView];
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
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bacImageView.mas_top).offset(6);
        make.right.equalTo(self.bacImageView.mas_right).offset(-8);
        make.width.height.offset(21/568.0 *kSCREEN_Width);
    }];
    
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bacImageView.mas_left).offset(5);
        make.right.equalTo(self.bacImageView.mas_right).offset(-5);
        make.bottom.equalTo(self.bacImageView.mas_bottom).offset(-15);
    }];
}


- (void)setMessageArray:(NSArray *)messageArray{
    
    _messageArray = messageArray;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageArray.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZMessageCell *cell = (MZMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"MZMessageCell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MZMessageCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.messageArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UIImageView *)bacImageView{
    
    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.image = [UIImage imageNamed:@"loggyAlertBacImage"];
    }
    return _bacImageView;
}

- (UITableView *)messageTableView{
    
    if(!_messageTableView){
        
        _messageTableView = [[UITableView alloc] init];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.backgroundColor = [UIColor clearColor];
        _messageTableView.estimatedRowHeight = 100;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _messageTableView;
}
- (UIButton *)closeButton{
    
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"shadeClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"消息";
    }
    return _titleLabel;
}


@end
