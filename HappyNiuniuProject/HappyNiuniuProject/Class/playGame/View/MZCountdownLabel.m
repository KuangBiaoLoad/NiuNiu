//
//  MZCountdownLabel.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZCountdownLabel.h"

@implementation MZCountdownLabel

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
    self.textColor = [UIColor greenColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:14];
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 1.0f;
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
    
    self.text = [NSString stringWithFormat:@"%02d",_totalTime --];
    if (_totalTime == -1){
        [self reloadTimer];
        if([_delegate respondsToSelector:@selector(countdowmEnd)]){
            [_delegate countdowmEnd];
        }
        
    }
    
}
@end
