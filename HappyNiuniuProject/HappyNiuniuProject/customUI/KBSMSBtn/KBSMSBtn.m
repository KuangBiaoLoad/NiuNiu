//
//  KBSMSBtn.m
//  ylShop
//
//  Created by Apple_KB on 2017/5/4.
//  Copyright © 2017年 eeepay. All rights reserved.
//

#import "KBSMSBtn.h"

@implementation KBSMSBtn


- (instancetype)init{

    if(self = [super init]){
    
        [self initTimer];
        [self setUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self = [super initWithCoder:aDecoder]){
    
        [self initTimer];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.titleLabel.font = [UIFont systemFontOfSize:15];
   
}

- (void)initTimer{
    if(_SMSTimer == nil){
    
        _SMSTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(enabledSms) userInfo:nil repeats:YES];
        [_SMSTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)reloadTimer{
    _totalTime = 60;
    self.enabled = YES;
    [_SMSTimer setFireDate:[NSDate distantFuture]];
    [self setTitle:self.titleStr forState:UIControlStateNormal];
}

- (void)enableTimer{
    _totalTime = 60;
    self.enabled = NO;
    [_SMSTimer setFireDate:[NSDate distantPast]];
    
}


- (void)enabledSms{
    _totalTime --;
    if(_totalTime == 0){
    
        [self reloadTimer];
    }else{
    
        [self setTitle:[NSString stringWithFormat:@"%@%dS",self.touchStr,_totalTime] forState:UIControlStateNormal];
    }

}


@end
