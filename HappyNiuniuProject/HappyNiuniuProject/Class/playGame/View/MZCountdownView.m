//
//  MZCountdownLabel.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZCountdownView.h"

@interface MZCountdownView()

@property (nonatomic, strong) UIImageView *bacImageView;
@property (nonatomic, strong) UILabel *countLabel;


@end

@implementation MZCountdownView

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self initView];
         [self initTimer];
    }
    return self;
}
- (id)init{
    
    self = [super init];
    if (self) {
         [self initView];
        [self initTimer];
        
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self initView];
        [self initTimer];
        
    }
    return self;
    
}

- (void)initView{
    [self addSubview:self.bacImageView];
    [self addSubview:self.countLabel];
    [self.bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bacImageView.mas_centerY).offset(0);
        make.centerX.equalTo(self.bacImageView.mas_centerX).offset(0);
        make.height.offset(22);
    }];
}



- (void)initTimer{
    
    if (!_SMSTimer){
        _SMSTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(enabledSms) userInfo:nil repeats:YES];
        _SMSTimer.fireDate = [NSDate distantFuture];
    }
}

- (void)enableTimer{

    _totalTime = 5;
    _SMSTimer.fireDate = [NSDate distantPast];
}

- (void)reloadTimer{
    
    _totalTime = 5;
    _SMSTimer.fireDate = [NSDate distantFuture];
    
}

- (void)enabledSms{
    
    self.countLabel.text = [NSString stringWithFormat:@"%01d",_totalTime --];
    if (_totalTime == -1){
        [self reloadTimer];
        if([_delegate respondsToSelector:@selector(countdowmEnd)]){
            [_delegate countdowmEnd];
        }
        
    }
    
}

- (UIImageView *)bacImageView{
    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.image = [UIImage imageNamed:@"check_alarmClock"];
    }
    return _bacImageView;
}

- (UILabel *)countLabel{

    if(!_countLabel){
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:27];
        _countLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _countLabel;
}
@end
