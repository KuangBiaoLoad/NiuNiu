//
//  MZSettingView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/11.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZSettingView.h"
#import "ZJSwitch.h"
#import "MZGameLobbyController.h"
#import "MZLoginController.h"
@interface MZSettingView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bacImageView;    //背景图
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UIButton *closeButton;        //取消按钮

@property (nonatomic, strong) UIImageView *musicBacImageView;
@property (nonatomic, strong) UIImageView *soundEffectBacImageView;
@property (nonatomic, strong) UIImageView *vibrateBacImageView;
@property (nonatomic, strong) UIImageView *languageBacImageView;

@property (nonatomic, strong) UILabel *musicLabel;
@property (nonatomic, strong) UILabel *soundEffectLabel;
@property (nonatomic, strong) UILabel *vibrateLabel;
@property (nonatomic, strong) UILabel *languageLabel;

@property (nonatomic, strong) ZJSwitch *musicSwitch;
@property (nonatomic, strong) ZJSwitch *soundEffectSwitch;
@property (nonatomic, strong) ZJSwitch *vibrateSwitch;
@property (nonatomic, strong) ZJSwitch *languageSwitch;

@property (nonatomic, strong) UIScrollView *setScrollView;
@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation MZSettingView


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
    [self addSubview:self.closeButton];
    [self addSubview:self.setScrollView];
    [self.setScrollView addSubview:self.musicBacImageView];
    [self.setScrollView addSubview:self.soundEffectBacImageView];
    [self.setScrollView addSubview:self.vibrateBacImageView];
    [self.setScrollView addSubview:self.languageBacImageView];
    [self.setScrollView addSubview:self.musicLabel];
    [self.setScrollView addSubview:self.soundEffectLabel];
    [self.setScrollView addSubview:self.vibrateLabel];
    [self.setScrollView addSubview:self.languageLabel];
    [self.setScrollView addSubview:self.musicSwitch];
    [self.setScrollView addSubview:self.soundEffectSwitch];
    [self.setScrollView addSubview:self.vibrateSwitch];
    [self.setScrollView addSubview:self.languageSwitch];
    [self.setScrollView addSubview:self.logoutBtn];
    self.setScrollView.contentSize = CGSizeMake(0, 200 * KSCREEN_HEIGHT / 320.0f);
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
    [self.setScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.bacImageView.mas_left).offset(5);
        make.right.equalTo(self.bacImageView.mas_right).offset(-5);
        make.bottom.equalTo(self.bacImageView.mas_bottom).offset(-15);
    }];
    
    [self.musicBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setScrollView.mas_bottom).offset(5);
        make.left.equalTo(self.bacImageView.mas_left).offset(15);
        make.right.equalTo(self.bacImageView.mas_right).offset(-15);
        make.height.equalTo(self.musicBacImageView.mas_width).multipliedBy(29/308.0);
    }];
    [self.soundEffectBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicBacImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bacImageView.mas_left).offset(15);
        make.right.equalTo(self.bacImageView.mas_right).offset(-15);
        make.height.equalTo(self.musicBacImageView.mas_width).multipliedBy(29/308.0);
        
    }];
    [self.vibrateBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.soundEffectBacImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bacImageView.mas_left).offset(15);
        make.right.equalTo(self.bacImageView.mas_right).offset(-15);
        make.height.equalTo(self.musicBacImageView.mas_width).multipliedBy(29/308.0);
        
    }];
    [self.languageBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vibrateBacImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bacImageView.mas_left).offset(15);
        make.right.equalTo(self.bacImageView.mas_right).offset(-15);
        make.height.equalTo(self.musicBacImageView.mas_width).multipliedBy(29/308.0);
        
    }];
    [self.musicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicBacImageView.mas_left).offset(40);
        make.centerY.equalTo(self.musicBacImageView.mas_centerY).offset(0);
    }];
    [self.soundEffectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soundEffectBacImageView.mas_left).offset(40);
        make.centerY.equalTo(self.soundEffectBacImageView.mas_centerY).offset(0);
    }];
    [self.vibrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vibrateBacImageView.mas_left).offset(40);
        make.centerY.equalTo(self.vibrateBacImageView.mas_centerY).offset(0);
    }];
    [self.languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.languageBacImageView.mas_left).offset(40);
        make.centerY.equalTo(self.languageBacImageView.mas_centerY).offset(0);
    }];
    [self.musicSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.musicBacImageView.mas_right).offset(-60);
        make.centerY.equalTo(self.musicBacImageView.mas_centerY).offset(0);
        make.width.offset(53);
    }];
    [self.soundEffectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.soundEffectBacImageView.mas_right).offset(-60);
        make.centerY.equalTo(self.soundEffectBacImageView.mas_centerY).offset(0);
        make.width.offset(53);
    }];
    [self.vibrateSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vibrateBacImageView.mas_right).offset(-60);
        make.centerY.equalTo(self.vibrateBacImageView.mas_centerY).offset(0);
        make.width.offset(53);
    }];
    [self.languageSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.languageBacImageView.mas_right).offset(-60);
        make.centerY.equalTo(self.languageBacImageView.mas_centerY).offset(0);
        make.width.offset(53);
    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.languageBacImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.bacImageView.mas_centerX).offset(0);
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

- (void)logoutBtnClickAction:(UIButton *)sender{
    MZLoginController * loginVC = [[MZLoginController alloc] initWithNibName:@"MZLoginController" bundle:nil];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
    
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
        _titleLabel.text = @"设置";
    }
    return _titleLabel;
}
- (UIButton *)closeButton{
    
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"shadeClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)musicBacImageView{

    if(!_musicBacImageView){
        _musicBacImageView = [[UIImageView alloc] init];
        _musicBacImageView.image = [UIImage imageNamed:@"loggyAlertBaseboard"];
    }
    return _musicBacImageView;
}

- (UIImageView *)vibrateBacImageView{
    
    if(!_vibrateBacImageView){
        _vibrateBacImageView = [[UIImageView alloc] init];
        _vibrateBacImageView.image = [UIImage imageNamed:@"loggyAlertBaseboard"];
    }
    return _vibrateBacImageView;
}

- (UIImageView *)languageBacImageView{
    
    if(!_languageBacImageView){
        _languageBacImageView = [[UIImageView alloc] init];
        _languageBacImageView.image = [UIImage imageNamed:@"loggyAlertBaseboard"];
    }
    return _languageBacImageView;
}

- (UIImageView *)soundEffectBacImageView{
    
    if(!_soundEffectBacImageView){
        _soundEffectBacImageView = [[UIImageView alloc] init];
        _soundEffectBacImageView.image = [UIImage imageNamed:@"loggyAlertBaseboard"];
    }
    return _soundEffectBacImageView;
}

- (UILabel *)musicLabel{

    if(!_musicLabel){
        _musicLabel = [[UILabel alloc] init];
        _musicLabel.textColor = [UIColor colorWithHexString:@"775E3A"];
        _musicLabel.font = [UIFont systemFontOfSize:12];
        _musicLabel.text = @"音乐";
    }
    return _musicLabel;
}
- (UILabel *)soundEffectLabel{
    
    if(!_soundEffectLabel){
        _soundEffectLabel = [[UILabel alloc] init];
        _soundEffectLabel.textColor = [UIColor colorWithHexString:@"775E3A"];
        _soundEffectLabel.font = [UIFont systemFontOfSize:12];
        _soundEffectLabel.text = @"音效";
    }
    return _soundEffectLabel;
}
- (UILabel *)vibrateLabel{
    
    if(!_vibrateLabel){
        _vibrateLabel = [[UILabel alloc] init];
        _vibrateLabel.textColor = [UIColor colorWithHexString:@"775E3A"];
        _vibrateLabel.font = [UIFont systemFontOfSize:12];
        _vibrateLabel.text = @"振动";
    }
    return _vibrateLabel;
}
- (UILabel *)languageLabel{
    
    if(!_languageLabel){
        _languageLabel = [[UILabel alloc] init];
        _languageLabel.textColor = [UIColor colorWithHexString:@"775E3A"];
        _languageLabel.font = [UIFont systemFontOfSize:12];
        _languageLabel.text = @"语言";
    }
    return _languageLabel;
}

- (ZJSwitch *)musicSwitch{

    if(!_musicSwitch){
        _musicSwitch = [[ZJSwitch alloc] init];
        _musicSwitch.backgroundColor = [UIColor clearColor];
        _musicSwitch.tintColor = [UIColor colorWithHexString:@"5e3e2c"];
        _musicSwitch.thumbImage = @"loggyAlertSwitchBtn";
        _musicSwitch.tag = 100;
        _musicSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"music"];
        _musicSwitch.onText = RDLocalizedString(@"on");
        _musicSwitch.offText = RDLocalizedString(@"off");
        [_musicSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];

    }
    return _musicSwitch;
}
- (ZJSwitch *)soundEffectSwitch{
    
    if(!_soundEffectSwitch){
        _soundEffectSwitch = [[ZJSwitch alloc] init];
        _soundEffectSwitch.backgroundColor = [UIColor clearColor];
         _soundEffectSwitch.tintColor = [UIColor colorWithHexString:@"5e3e2c"];
        _soundEffectSwitch.thumbImage = @"loggyAlertSwitchBtn";
        _soundEffectSwitch.tag = 101;
        _soundEffectSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundEffect"];
        _soundEffectSwitch.onText = RDLocalizedString(@"on");
        _soundEffectSwitch.offText = RDLocalizedString(@"off");
        [_soundEffectSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _soundEffectSwitch;
}
- (ZJSwitch *)vibrateSwitch{
    
    if(!_vibrateSwitch){
        _vibrateSwitch = [[ZJSwitch alloc] init];
        _vibrateSwitch.backgroundColor = [UIColor clearColor];
         _vibrateSwitch.tintColor = [UIColor colorWithHexString:@"5e3e2c"];
        _vibrateSwitch.thumbImage = @"loggyAlertSwitchBtn";
        _vibrateSwitch.tag = 102;
        _vibrateSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"vibrate"];
        _vibrateSwitch.onText = RDLocalizedString(@"on");
        _vibrateSwitch.offText = RDLocalizedString(@"off");
        [_vibrateSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _vibrateSwitch;
}
- (ZJSwitch *)languageSwitch{
    
    if(!_languageSwitch){
        _languageSwitch = [[ZJSwitch alloc] init];
        _languageSwitch.backgroundColor = [UIColor clearColor];
        _languageSwitch.tintColor = [UIColor colorWithHexString:@"5e3e2c"];
//        _languageSwitch.thumbTintColor = [UIColor colorWithHexString:@"e19a39"];
        _languageSwitch.thumbImage = @"loggyAlertSwitchBtn";
        _languageSwitch.tag = 103;
        _languageSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"language"];
        _languageSwitch.onText = RDLocalizedString(@"chn");;
        _languageSwitch.offText = RDLocalizedString(@"en");
        [_languageSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _languageSwitch;
}

- (UIScrollView *)setScrollView{
    
    if(!_setScrollView){
        _setScrollView = [[UIScrollView alloc] init];
        _setScrollView.delegate = self;
        _setScrollView.backgroundColor = [UIColor clearColor];
        _setScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _setScrollView;
}

- (UIButton *)logoutBtn{

    if(!_logoutBtn){
    
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:RDLocalizedString(@"logout") forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_logoutBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        [_logoutBtn addTarget:self action:@selector(logoutBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

#pragma mark - UIControlEventValueChanged
- (void)handleSwitchEvent:(ZJSwitch *)sender{
    
    switch (sender.tag) {
        case 100:{
        
            if (sender.on) {
                //开启音乐
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"music"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                //关闭音乐
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"music"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
            break;
        case 101:{
            if (sender.on) {
                //开启音效
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"soundEffect"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                //关闭音效
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"soundEffect"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
            break;
        case 102:{
            
            if (sender.on) {
                //开启振动
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"vibrate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                //关闭振动
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"vibrate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
            break;
        case 103:{
            
            if (sender.on) {
                //中文
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"language"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                [self hiddenView];
                [MZlocalizableContoller setUserlanguage:RDCHINESE];
                MZGameLobbyController *gameVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
                UINavigationController *gameNav = [[UINavigationController alloc] initWithRootViewController:gameVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = gameNav;
            }else{
                //英文
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"language"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                [self hiddenView];
                [MZlocalizableContoller setUserlanguage:RDENGLISH];
                MZGameLobbyController *gameVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
                UINavigationController *gameNav = [[UINavigationController alloc] initWithRootViewController:gameVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = gameNav;

            }
        }
            break;
            
        default:
            break;
    }
    NSLog(@"sender.tag = %ld, bool = %d",sender.tag,sender.on);
    
}
@end
