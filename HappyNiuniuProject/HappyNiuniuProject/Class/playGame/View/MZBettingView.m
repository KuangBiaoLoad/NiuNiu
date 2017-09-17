//
//  MZBettingView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/14.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBettingView.h"

@interface MZBettingView ()
@property (nonatomic, assign) int  maxSlide;                  //最大值
@property (nonatomic, assign) int  minSlide;                  //最小值
@property (nonatomic, strong) UIImageView *bacImageView;
@property (nonatomic, strong) UISlider *slide;              //滑动条
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *minMoneyLabel;
@property (nonatomic, strong) UILabel *maxMoneyLabel;
@property (nonatomic, strong) UIImageView *goldBacImage;
@property (nonatomic, strong) UIImageView *moneyBackIamge;
@property (nonatomic, strong) UILabel   *moneyLabel;
@property (nonatomic, strong) UIButton  *determineBtn;
@end


//419 *215
@implementation MZBettingView

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bacImageView];
        [self addSubview:self.slide];
        [self addSubview:self.minLabel];
        [self addSubview:self.maxLabel];
        [self addSubview:self.minMoneyLabel];
        [self addSubview:self.maxMoneyLabel];
        [self addSubview:self.moneyBackIamge];
        [self addSubview:self.goldBacImage];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.determineBtn];
        
        [self.bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.offset(2);
        }];
        [self.slide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.offset(self.width - 120);
            make.top.offset(16);
            make.height.offset(5);
        }];

        [self.minMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        [self.maxMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.slide.mas_centerY).offset(0);
        }];
        [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.minMoneyLabel.mas_bottom).offset(0);
            make.left.equalTo(self.minMoneyLabel.mas_left).offset(0);
        }];
        [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.maxMoneyLabel.mas_bottom).offset(0);
            make.right.equalTo(self.maxMoneyLabel.mas_right).offset(0);
        }];
        [self.moneyBackIamge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.offset(78);
            make.height.offset(20);
            make.top.equalTo(self.slide.mas_bottom).offset(13);
        }];
        [self.goldBacImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moneyBackIamge.mas_left).offset(0);
            make.centerY.equalTo(self.moneyBackIamge.mas_centerY).offset(0);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goldBacImage.mas_right).offset(2);
            make.centerY.equalTo(self.moneyBackIamge.mas_centerY).offset(0);
        }];
        [self.determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.moneyBackIamge.mas_bottom).offset(7);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.offset(72);
            make.height.offset(32);
        }];

     
    }
    return self;
}

- (void)setMaxMoney:(int)maxMoney{
    _maxMoney = maxMoney;
    self.maxSlide = maxMoney;
    self.slide.maximumValue = maxMoney;
    
    self.maxMoneyLabel.text = [NSString stringWithFormat:@"$%d",maxMoney];
    
}
-(void)setMinMoney:(int)minMoney{

    _minMoney = minMoney;
    self.minSlide = minMoney;
    self.slide.minimumValue =minMoney;
    self.minMoneyLabel.text = [NSString stringWithFormat:@"$%d",minMoney];
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",minMoney];
}

- (void)hiddenView{

    [self removeFromSuperview];
    if([_delegate respondsToSelector:@selector(bettingWithMoney:)]){
        [_delegate bettingWithMoney:self.slide.value];
    }
}

- (void)determineBtnClickAction:(UIButton *)sender{
    [self hiddenView];
}
- (void)sliderValueChanged:(id)sender{
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",(int)self.slide.value];
}

- (UIImageView *)bacImageView{

    if(!_bacImageView){
        _bacImageView = [[UIImageView alloc] init];
        _bacImageView.image = [UIImage imageNamed:@"boomBacImage"];
    }
    return _bacImageView;
}

- (UISlider *)slide{
    
    if(!_slide){
        _slide = [[UISlider alloc] init];
        _slide.value = 0;// 设置初始值
        _slide.continuous = YES;// 设置可连续变化
        [_slide setThumbImage:[UIImage imageNamed:@"boomSmallGold"] forState:UIControlStateNormal];
        [_slide setMinimumTrackImage:[UIImage imageNamed:@"boomBarImage"] forState:UIControlStateNormal];
        [_slide setMaximumTrackImage:[UIImage imageNamed:@"boomBarImage"] forState:UIControlStateNormal];
        [_slide addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    }
    return _slide;
}

- (UILabel *)minLabel{
    
    if(!_minLabel){
        _minLabel = [[UILabel alloc] init];
        _minLabel.font = [UIFont systemFontOfSize:9];
        _minLabel.textColor = [UIColor colorWithHexString:@"FFE012"];
        _minLabel.shadowColor = [UIColor colorWithHexString:@"FFE012"];
        _minLabel.shadowOffset = CGSizeMake(0, 1);
        _minLabel.text = RDLocalizedString(@"minimum");
    }
    return _minLabel;
}

-(UILabel *)maxLabel{
    
    if(!_maxLabel){
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.font = [UIFont systemFontOfSize:9];
        _maxLabel.textColor = [UIColor colorWithHexString:@"FFE012"];
        _maxLabel.text = RDLocalizedString(@"maximum");
        _maxLabel.shadowColor = [UIColor colorWithHexString:@"FFE012"];
        _maxLabel.shadowOffset = CGSizeMake(0, 1);
    }
    return _maxLabel;
}
- (UILabel *)minMoneyLabel{
    
    if(!_minMoneyLabel){
        _minMoneyLabel = [[UILabel alloc] init];
        _minMoneyLabel.font = [UIFont systemFontOfSize:12];
        _minMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _minMoneyLabel;
}

- (UILabel *)maxMoneyLabel{
    
    if(!_maxMoneyLabel){
        _maxMoneyLabel = [[UILabel alloc] init];
        _maxMoneyLabel.font = [UIFont systemFontOfSize:12];
        _maxMoneyLabel.textColor = [UIColor whiteColor];
    }
    return _maxMoneyLabel;
}

- (UIImageView *)goldBacImage{

    if(!_goldBacImage){
        _goldBacImage = [[UIImageView alloc] init];
        _goldBacImage.image = [UIImage imageNamed:@"gold"];
    }
    return _goldBacImage;
}

- (UIImageView *)moneyBackIamge{
    
    if(!_moneyBackIamge){
        _moneyBackIamge = [[UIImageView alloc] init];
        _moneyBackIamge.image = [UIImage imageNamed:@"check_bottomFrame"];
    }
    return _moneyBackIamge;
}

- (UILabel *)moneyLabel{

    if(!_moneyLabel){
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.font = [UIFont systemFontOfSize:12];
    }
    return _moneyLabel;
}

- (UIButton *)determineBtn{

    if(!_determineBtn){
        _determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_determineBtn setBackgroundImage: [UIImage imageNamed:@"check_boomPourImage"] forState:UIControlStateNormal];
        [_determineBtn addTarget:self action:@selector(determineBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_determineBtn setTitle:RDLocalizedString(@"determine") forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    }
    return _determineBtn;
}


@end
