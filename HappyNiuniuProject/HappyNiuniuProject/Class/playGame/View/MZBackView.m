//
//  MZBackView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/15.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBackView.h"


@interface MZBackView ()

@property (nonatomic, strong) UIImageView *bacImageView;
@property (nonatomic, strong) UIButton *leaveRoomBtn;       //离开房间

@end

@implementation MZBackView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bacImageView];
    [self addSubview:self.gotUpbtn];
    [self addSubview:self.leaveRoomBtn];
    [self.bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
    [self.gotUpbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.width.offset(72);
        make.height.offset(25);
    }];
    [self.leaveRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gotUpbtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.width.offset(72);
        make.height.offset(25);
    }];
}

- (void)btnClickAction:(UIButton *)sender{
    if([_deleagte respondsToSelector:@selector(clickButtonWithTag:)]){
        
        [_deleagte clickButtonWithTag:(int)sender.tag];
    }
}

- (void)hiddenView{
    
    [self removeFromSuperview];
}

#pragma mark - 懒加载

- (UIImageView *)bacImageView{
    
    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.image = [UIImage imageNamed:@"check_boomVertical"];
    }
    return _bacImageView;
}

- (UIButton *)gotUpbtn{
    
    if(!_gotUpbtn){
        _gotUpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotUpbtn.tag = 211;
        _gotUpbtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_gotUpbtn setTitle:RDLocalizedString(@"gotup") forState:UIControlStateNormal];
        [_gotUpbtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_gotUpbtn setBackgroundImage:[UIImage imageNamed:@"check_double"] forState:UIControlStateNormal];
        [_gotUpbtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotUpbtn;
}

- (UIButton *)leaveRoomBtn{
    
    if(!_leaveRoomBtn){
        
        _leaveRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leaveRoomBtn.tag = 212;
        _leaveRoomBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_leaveRoomBtn setTitle:RDLocalizedString(@"leave") forState:UIControlStateNormal];
        [_leaveRoomBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_leaveRoomBtn setBackgroundImage:[UIImage imageNamed:@"check_double"] forState:UIControlStateNormal];
        [_leaveRoomBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leaveRoomBtn;
}

@end
