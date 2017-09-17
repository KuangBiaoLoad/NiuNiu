//
//  MZOverlapView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/28.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZOverlapView.h"
#import "MZCardListModel.h"
#import "MZlocalizableContoller.h"
@implementation MZOverlapView
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
    self.showNiuImageView = [[UIImageView alloc] init];
    self.showNiuImageView.image = [UIImage imageNamed:@"check_niu4"];
}

- (void)overlapWidth:(CGFloat)width withScaleWidth:(CGFloat)scaleWidth{
    
    for(int i = 0; i<5; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 10+i;
        imageView.image = [UIImage imageNamed:@""];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(scaleWidth*i);
            make.width.offset(width);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    [self addSubview:self.showNiuImageView];
    [self.showNiuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(5);
        make.height.equalTo(self.mas_height);
        
    }];
}

- (void)setOverlapImageArray:(NSArray *)overlapImageArray{
    
    _overlapImageArray = overlapImageArray;
    //黑桃S 红心H 方块D  梅花C  牌色 4：黑，3：红，2：梅，1：方
    for(int i=0; i<overlapImageArray.count; i++){
        MZCardListModel *model = _overlapImageArray[i];
        NSString *cardStr = @"";
        NSString *color = model.color;
        switch ([color intValue]) {
            case 1:
                cardStr =  [cardStr stringByAppendingString:@"D"];
                break;
            case 2:
                cardStr = [cardStr stringByAppendingString:@"C"];
                break;
            case 3:
                cardStr = [cardStr stringByAppendingString:@"H"];
                break;
            case 4:
                cardStr = [cardStr stringByAppendingString:@"S"];
                break;
                
            default:
                break;
        }
        cardStr =  [cardStr stringByAppendingString:model.cardNumber];
        UIImageView *imageView = (UIImageView *)[self viewWithTag:10+i];
        imageView.image = [UIImage imageNamed:cardStr];
    }
    
}

-(void)setCardNorImage:(NSString *)cardNorImage{

    _cardNorImage = cardNorImage;
    for(int i=0; i< 5; i++){
        UIImageView *imageView = (UIImageView *)[self viewWithTag:10+i];
        imageView.image = [UIImage imageNamed:@"backCard"];
    }
}

- (void)setShapeStr:(NSString *)shapeStr{

    _shapeStr = shapeStr;
    if([[MZlocalizableContoller userLanguage] isEqualToString:RDCHINESE]){
        self.showNiuImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"checkcn_niu%@",shapeStr]];
    }else{
        self.showNiuImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"checken_niu%@",shapeStr]];
    }
    
}

@end
