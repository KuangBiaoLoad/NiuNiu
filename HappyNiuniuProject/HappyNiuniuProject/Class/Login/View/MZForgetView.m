//
//  MZForgetView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/31.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZForgetView.h"

@interface MZForgetView ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *mobileView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIView *passwordView;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *resetPwdBtn;

@end

@implementation MZForgetView


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

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
        [tap setDelegate:self];
        [self addSubview:self.backgroungView];
        [self.backgroundView  addSubview:self.mobileView];
        [self.backgroundView  addSubview:self.codeView];
        [self.backgroundView  addSubview:self.passwordView];
        [self.backgroundView  addSubview:self.resetPwdBtn];
        [self.codeView addSubview:self.codeBtn];
        [self.mobileView  addSubview:self.mobileLabel];
        [self.codeView  addSubview:self.codeLabel];
        [self.passwordView  addSubview:self.passwordLabel];
        [self.mobileView  addSubview:self.mobileTextField];
        [self.codeView  addSubview:self.codeTextField];
        [self.passwordView  addSubview:self.passwordTextField];
        [self.mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.offset(-20);
            make.top.offset(20);
            make.height.mas_equalTo(self.mobileView.mas_width).multipliedBy(1/8.9);
        }];
        [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.offset(-20);
            make.top.equalTo(self.mobileView.mas_bottom).offset(10);
            make.height.mas_equalTo(self.mobileView.mas_width).multipliedBy(1/8.9);
        }];
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.offset(-20);
            make.top.equalTo(self.codeView.mas_bottom).offset(10);
            make.height.mas_equalTo(self.mobileView.mas_width).multipliedBy(1/8.9);
        }];
        [self.resetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundView.mas_centerX).offset(0);
            make.width.equalTo(self.backgroundView.mas_width).multipliedBy(0.47);
            make.height.equalTo(self.resetPwdBtn.mas_width).multipliedBy(1/3.7);
            make.top.equalTo(self.passwordView.mas_bottom).offset(20);
        }];
        [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset(95);
            make.centerY.equalTo(self.mobileView.mas_centerY).offset(0);
        }];
        [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset(50);
            make.centerY.equalTo(self.codeView.mas_centerY).offset(0);
        }];
        [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset(95);
            make.centerY.equalTo(self.passwordView.mas_centerY).offset(0);
        }];
        [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mobileLabel.mas_right).offset(5);
            make.right.offset(-20);
            make.centerY.equalTo(self.mobileView.mas_centerY).offset(0);
        }];
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.codeLabel.mas_right).offset(5);
            make.centerY.equalTo(self.codeView.mas_centerY).offset(0);
            make.right.equalTo(self.codeBtn.mas_left).offset(-5);
        }];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passwordLabel.mas_right).offset(5);
            make.centerY.equalTo(self.passwordView.mas_centerY).offset(0);
            make.right.offset(-20);
        }];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-5);
            make.top.offset(5);
            make.bottom.offset(-5);
        }];
    }
    return self;
}


- (void)hiddenView{
    
    [self removeFromSuperview];
}

- (void)RequestWithForgetPassword{
    
}

#pragma mark - UIButtonAction
//重设密码
- (void)resetBtnClickAction:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(ForgetPasswordRequestSuccessBlock)]){
        [_delegate ForgetPasswordRequestSuccessBlock];
        [self hiddenView];
    }
}
//获取验证码
- (void)codeBtnClickAction:(UIButton *)sender{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self);
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.mobileTextField){
        if([toBeString length]>11){
            return NO;
        }
    }
    if(textField == self.codeTextField){
        if([toBeString length]>6){
            return NO;
        }
    }
    return YES;
}



#pragma mark - 懒加载
- (UIView *)backgroungView{
    
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.4/2.0, (self.frame.size.height * 0.325)/2.0, self.frame.size.width *0.6, self.frame.size.height * 0.675)];
        _backgroundView.backgroundColor = [UIColor colorWithHexString:@"fef6e9"];
        _backgroundView.layer.borderWidth = 2.0f;
        _backgroundView.layer.borderColor = [UIColor colorWithHexString:@"603f11"].CGColor;
        _backgroundView.layer.cornerRadius =5.0f;
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}
- (UIView *)mobileView{
    if(!_mobileView){
        _mobileView = [[UIView alloc] init];
        _mobileView.backgroundColor = [UIColor colorWithHexString:@"603f11"];
    }
    return _mobileView;
}
- (UIView *)codeView{
    if(!_codeView){
        _codeView = [[UIView alloc] init];
        _codeView.backgroundColor = [UIColor colorWithHexString:@"603f11"];
    }
    return _codeView;
}
- (UIView *)passwordView{
    if(!_passwordView){
        _passwordView = [[UIView alloc] init];
        _passwordView.backgroundColor = [UIColor colorWithHexString:@"603f11"];
    }
    return _passwordView;
}

- (UIButton *)resetPwdBtn{

    if(!_resetPwdBtn){
        _resetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetPwdBtn setTitle:@"重设密码" forState:UIControlStateNormal];
        [_resetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetPwdBtn addTarget:self action:@selector(resetBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _resetPwdBtn.backgroundColor = [UIColor colorWithHexString:@"72b637"];
    }
    return _resetPwdBtn;
}

- (UILabel *)mobileLabel{
    if(!_mobileLabel){
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.text = @"请输入手机号";
        _mobileLabel.textColor = [UIColor whiteColor];
        _mobileLabel.textAlignment = NSTextAlignmentLeft;
        _mobileLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mobileLabel;
}

- (UILabel *)codeLabel{
    if(!_codeLabel){
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.text = @"验证码";
        _codeLabel.textColor = [UIColor whiteColor];
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        _codeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _codeLabel;
}

- (UILabel *)passwordLabel{
    if(!_passwordLabel){
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"请输入新密码";
        _passwordLabel.textColor = [UIColor whiteColor];
        _passwordLabel.textAlignment = NSTextAlignmentLeft;
        _passwordLabel.font = [UIFont systemFontOfSize:15];
    }
    return _passwordLabel;
}

- (UITextField *)mobileTextField{

    if(!_mobileTextField){
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.placeholder = @"请输入手机号码";
        _mobileTextField.delegate = self;
        _mobileTextField.textColor = [UIColor whiteColor];
        _mobileTextField.font = [UIFont systemFontOfSize:15];
        [_mobileTextField setValue:[UIColor colorWithHexString:@"766248"] forKeyPath:@"_placeholderLabel.textColor"];
        [_mobileTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return _mobileTextField;
}

- (UITextField *)codeTextField{
    
    if(!_codeTextField){
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.placeholder = @"验证码";
        _codeTextField.delegate = self;
        _codeTextField.textColor = [UIColor whiteColor];
        _codeTextField.font = [UIFont systemFontOfSize:15];
        [_codeTextField setValue:[UIColor colorWithHexString:@"766248"] forKeyPath:@"_placeholderLabel.textColor"];
        [_codeTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return _codeTextField;
}

- (UITextField *)passwordTextField{
    
    if(!_passwordTextField){
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"请输入新密码";
        _passwordTextField.delegate = self;
        _passwordTextField.textColor = [UIColor whiteColor];
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        [_passwordTextField setValue:[UIColor colorWithHexString:@"766248"] forKeyPath:@"_placeholderLabel.textColor"];
        [_passwordTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return _passwordTextField;
}

- (UIButton *)codeBtn{

    if(!_codeBtn){
    
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.backgroundColor = [UIColor colorWithHexString:@"f7d64a"];
        _codeBtn.layer.cornerRadius = 10.0f;
        _codeBtn.clipsToBounds = YES;
    }
    return _codeBtn;
}


@end
