//
//  MZUserView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZUserView.h"

@interface MZUserView ()

@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bacImageView;
@property (nonatomic, strong) UIButton *userBacImageView;
@property (nonatomic, strong) UIImageView *goldBacImageView;
@property (nonatomic, strong) UIImageView *goldImageView;
@end

@implementation MZUserView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}
- (id)init{
    
    self = [super init];
    if (self) {
         [self initView];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self initView];
    }
    return self;
    
}
- (void)initView{
    
}


- (void)userDirection:(directionType)type withImageUrl:(NSString *)imageStr withUserNameStr:(NSString *)userStr withGoldStr:(NSString *)goldStr{
    [self addSubview:self.bacImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.userBacImageView];
    [self addSubview:self.goldBacImageView];
    [self addSubview:self.goldImageView];
    [self addSubview:self.userLabel];
    [self addSubview:self.goldLabel];
    self.imageView.image = [UIImage imageNamed:imageStr];
    self.userLabel.text = userStr;
    self.goldLabel.text = goldStr;
    [self.bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    switch (type) {
        case horizontalDirectionType:{
            
            self.bacImageView.image = [UIImage imageNamed:@"check_boomHorizontal"];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(4);
                make.centerY.equalTo(self.mas_centerY).offset(-2);
                make.top.offset(5);
                make.width.equalTo(self.imageView.mas_height).multipliedBy(1);
            }];
            [self.userBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(0);
                make.centerY.equalTo(self.imageView.mas_centerY).offset(-10);
                make.right.equalTo(self.mas_right).offset(0);
                make.height.offset(20);
            }];
            [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userBacImageView.mas_left).offset(5);
                make.centerY.equalTo(self.userBacImageView.mas_centerY).offset(0);
                make.right.equalTo(self.userBacImageView.mas_right).offset(0);
            }];
            [self.goldBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(0);
                make.centerY.equalTo(self.imageView.mas_centerY).offset(10);
                make.right.equalTo(self.mas_right).offset(-2);
                make.height.offset(20);
            }];
            [self.goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(21);
                make.height.offset(22);
                make.left.equalTo(self.goldBacImageView.mas_left).offset(0);
                make.centerY.equalTo(self.goldBacImageView.mas_centerY).offset(0);
            }];
            [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.goldImageView.mas_right).offset(0);
                make.centerY.equalTo(self.goldBacImageView.mas_centerY).offset(0);
                make.right.equalTo(self.goldBacImageView.mas_right).offset(0);
                make.height.offset(20);
            }];
    }
            break;
        case verticalDirectionType:{
            
            self.bacImageView.image = [UIImage imageNamed:@"check_boomVertical"];
            self.userLabel.textAlignment = NSTextAlignmentCenter;
            self.goldLabel.textAlignment = NSTextAlignmentCenter;
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(2);
                make.centerX.equalTo(self.mas_centerX).offset(0);
                make.left.offset(5);
                make.width.equalTo(self.imageView.mas_height).multipliedBy(1);
            }];
            
            [self.userBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_bottom).offset(5);
                make.left.equalTo(self.mas_left).offset(0);
                make.right.equalTo(self.mas_right).offset(0);
            }];
            [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userBacImageView.mas_top).offset(0);
                make.left.equalTo(self.userBacImageView.mas_left).offset(0);
                make.right.equalTo(self.userBacImageView.mas_right).offset(0);
            }];
            [self.goldBacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userBacImageView.mas_bottom).offset(5);
                make.left.equalTo(self.mas_left).offset(0);
                make.right.equalTo(self.mas_right).offset(-2);
            }];
            [self.goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(21);
                make.height.offset(22);
                make.left.equalTo(self.goldBacImageView.mas_left).offset(0);
                make.centerY.equalTo(self.goldBacImageView.mas_centerY).offset(0);
            }];
            [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.goldBacImageView.mas_centerY).offset(0);
                make.left.equalTo(self.goldImageView.mas_right).offset(0);
                make.right.equalTo(self.mas_right).offset(0);
            }];
        }
            
            break;
        default:
            break;
    }
    
}


- (void)setUserDict:(NSDictionary *)userDict{

    _userDict = userDict;
    
    self.imageView.image = [UIImage imageNamed:[userDict objectForKey:@"image"]];
    self.userLabel.text = [userDict objectForKey:@"user"];
    self.goldLabel.text = [userDict objectForKey:@"gold"];
}
- (void)createUserCoradius:(CGFloat)coradiusStr{
      self.imageView.layer.cornerRadius = (coradiusStr - 10)/2.0;
}

- (UILabel *)userLabel{
    if(!_userLabel){
        _userLabel = [[UILabel alloc] init];
        _userLabel.textColor = [UIColor whiteColor];
        _userLabel.textAlignment = NSTextAlignmentLeft;
        _userLabel.font = [UIFont systemFontOfSize:11];
        _userLabel.adjustsFontSizeToFitWidth = YES;
        _userLabel.minimumScaleFactor = 0.5;
        
    }
    return _userLabel;
}

- (UILabel *)goldLabel{
    if(!_goldLabel){
        _goldLabel = [[UILabel alloc] init];
        _goldLabel.textColor = [UIColor yellowColor];
        _goldLabel.textAlignment = NSTextAlignmentLeft;
        _goldLabel.font = [UIFont systemFontOfSize:11];
        _goldLabel.adjustsFontSizeToFitWidth = YES;
        _goldLabel.minimumScaleFactor = 0.5;
    }
    return _goldLabel;
}
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
//        _imageView.image = [UIImage imageNamed:@"check_bankerHeadImage"];
    }
    return _imageView;
}

- (UIImageView *)bacImageView{

    if(!_bacImageView){
    
        _bacImageView = [[UIImageView alloc] init];
    }
    return _bacImageView;
}

- (UIButton *)userBacImageView{

    if(!_userBacImageView){
        _userBacImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userBacImageView setBackgroundImage:[UIImage imageNamed:@"photoCell"] forState:UIControlStateNormal];
//        _userBacImageView.image = [UIImage imageNamed:@"photoCell"];
    }
    return _userBacImageView;
}
- (UIImageView *)goldBacImageView{
    if(!_goldBacImageView){
        _goldBacImageView  = [[UIImageView alloc] init];
        _goldBacImageView.image = [UIImage imageNamed:@"check_bottomFrame"];
    }
    return _goldBacImageView;
}


- (UIImageView *)goldImageView{

    if(!_goldImageView){
        _goldImageView = [[UIImageView alloc] init];
        _goldImageView.image = [UIImage imageNamed:@"gold"];
    }
    return _goldImageView;
}

@end
