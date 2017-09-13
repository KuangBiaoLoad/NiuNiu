//
//  MZLobbySView.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/29.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZLobbySView.h"
#import "MZGameTypeModel.h"
#define kwhscale  (152.5 / 166)
#define kwidth  (self.frame.size.height * kwhscale)
@interface MZLobbySView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *lobbyScrollView;
@property (nonatomic, strong) NSArray        *lobbyArray;
@end

@implementation MZLobbySView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data{
    if(self = [super initWithFrame:frame]){
        self.lobbyArray = data;
        [self addSubview:self.lobbyScrollView];
        for(int i =0; i<data.count; i++){
            MZGameTypeModel *model = data[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 10+i;
            btn.frame = CGRectMake((kwidth) * i, 0, kwidth, self.frame.size.height);
            [btn setBackgroundImage:[UIImage imageNamed:@"room"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.lobbyScrollView addSubview:btn];
            UILabel *label = [[UILabel alloc] init];
            if([[MZlocalizableContoller userLanguage] isEqualToString:RDCHINESE]){
                 label.text = model.gametype_desccn;
            }else{
                 label.text = model.gametype_descen;
            }
            label.tag = 100 + i;
            label.textColor = [UIColor colorWithHexString:@"FFB71D"];
            label.font = [UIFont boldSystemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            [self.lobbyScrollView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.offset(2.22/10.76 * self.frame.size.height);
                make.width.offset(40);
                make.centerX.equalTo(btn.mas_centerX).offset(-8);
                make.height.offset(0.9/10.76 * self.frame.size.height);
                make.bottom.equalTo (btn.mas_bottom).offset(-28 /320.0 * KSCREEN_HEIGHT);
            }];
        }
    }
    return self;
    
}

- (void)btnClickAction:(UIButton *)sender{

    if([_delegate respondsToSelector:@selector(lobbyViewDidSelectWithIndexTag:)]){
    
        [_delegate lobbyViewDidSelectWithIndexTag:sender.tag];
    }
}


- (UIScrollView *)lobbyScrollView{

    if(!_lobbyScrollView){
        _lobbyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _lobbyScrollView.delegate = self;
        _lobbyScrollView.showsHorizontalScrollIndicator = NO;
        
        float viewidth = (kwidth) *(self.lobbyArray.count);
        _lobbyScrollView.contentSize = CGSizeMake(viewidth,self.bounds.size.height);
    }
    return _lobbyScrollView;
}

@end
