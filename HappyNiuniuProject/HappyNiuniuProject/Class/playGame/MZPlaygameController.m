//
//  MZPlaygameController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZPlaygameController.h"
#import "LGSocketServe.h"
#import "MZCountdownLabel.h"
#import "MZMultipleHog.h"
#import "MZPlayerModel.h"
#import "KDJSON.h"
#import "MZUserView.h"
#import "MZOverlapView.h"
#import "MZSpreadView.h"
#import "MZcalculateNiuView.h"
@interface MZPlaygameController ()<LGSocketServeDelegate,MZCountdownLabelDelegate,MZMultipleHogDelegate,MZSpreadViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;                //数据源
@property (nonatomic, strong) NSArray *titleArray;                      //弹框数组
@property (nonatomic, strong) UIImageView *tableBoardImageView;         //牌桌
@property (nonatomic, strong) MZCountdownLabel *countdownLabel;         //倒计时显示
@property (nonatomic, strong) MZPlayerModel *playerModel;               //用户模型
@property (nonatomic, strong) LGSocketServe *socketServe;               //socket请求类
@property (nonatomic, strong) MZMultipleHog *multiHogView;              //弹框View
@property (nonatomic, strong) MZcalculateNiuView *niuView;              //
@property (nonatomic, assign) ButtonType btnType;                       //枚举(准备，是否抢庄，倍数)
@property (nonatomic, assign) BOOL  isFirstLoad;                          //是否第一次加载

@end

@implementation MZPlaygameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self initView];
    [self.view addSubview:self.countdownLabel];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    if(!self.isFirstLoad){
    CGPoint startPoint = CGPointMake(kSCREEN_Width/2.0, KSCREEN_HEIGHT/2.0);
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        spreadView.hidden = NO;
        [self animateWithView:spreadView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(spreadView.frame.origin.x + spreadView.frame.size.width/2.0,spreadView.frame.origin.y + spreadView.frame.size.height/2.0)];
        
    });
    for (int i=0;i<5;i++){
        MZOverlapView *overlapView = (MZOverlapView *)[self.view viewWithTag:1000+i];
       
        CGFloat pointx = overlapView.frame.origin.x + overlapView.frame.size.width/2.0 ;
        CGFloat pointy =overlapView.frame.origin.y + overlapView.frame.size.height/2.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC * (i+1))), dispatch_get_main_queue(), ^{
             overlapView.hidden = NO;
            [self animateWithView:overlapView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(pointx,pointy)];
        });
    }
}
}

- (void)backBtnClickAction:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView{
    
    [self.view addSubview:self.tableBoardImageView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSArray *typeArray = @[@(verticalDirectionType),@(horizontalDirectionType),@(horizontalDirectionType),@(horizontalDirectionType),@(verticalDirectionType),@(horizontalDirectionType)];
    NSArray *imageArray = @[@"",@"",@"",@"",@"",@""];
    NSArray *userNameArray = @[@"kuangbiao",@"世界",@"helloworld",@"objective-c",@"易联支付",@"欢乐牛牛"];
    NSArray *goldArray = @[@"200.03万",@"12.09万",@"2.34万",@"1000.75万",@"34.78万",@"678.78万"];
    MZSpreadView *spreadView = [[MZSpreadView alloc] init];
    spreadView.tag = 10000;
    spreadView.hidden = YES;
    CGFloat spreadWidth = kSCREEN_Width/11.0f;
    CGFloat spreadScaleWidth = 5;
    spreadView.deleagte = self.niuView;
    [spreadView spreadWidth:spreadWidth withScaleWidth:spreadScaleWidth];
    //根据屏幕设置宽高比
    CGFloat kwidth = kSCREEN_Width/5.6f;
    CGFloat kheight = kwidth/2.0f;
    CGFloat khorWidth = kwidth/2.0f;
    CGFloat kverHeight = khorWidth * 1.6f;
    for(int i=0; i<6;i++){
        
        MZUserView *userView = [[MZUserView alloc] init];
        userView.tag = 100+i;
        directionType dirType;
        dirType = (i==0 ||i==4)?verticalDirectionType:horizontalDirectionType;
        [userView userDirection:dirType withImageUrl:imageArray[i] withUserNameStr:userNameArray[i] withGoldStr:goldArray[i]];
        [userView createUserCoradius:kheight];
        MZOverlapView *overlapView = [[MZOverlapView alloc] init];
        overlapView.hidden = YES;
        overlapView.tag = 1000 + i;
        CGFloat overlapWidth = kSCREEN_Width /6.3;
        CGFloat scaleWidth = overlapWidth/6.0;
        [overlapView overlapWidth:scaleWidth * 2 withScaleWidth:scaleWidth];
        [self.view addSubview:userView];
        [self.view addSubview:overlapView];
        [self.view addSubview:spreadView];
        if(i==0){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.centerY.equalTo(self.view).offset(15);
                make.width.offset(khorWidth);
                make.height.offset(kverHeight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *150/105);
                make.left.equalTo(userView.mas_right).offset(1);
                make.bottom.equalTo(userView.mas_bottom).offset(-10);
            }];
        }
        if(i==1){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(60);
                make.top.offset(20 + kheight*0.6);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *150/105);
                make.left.equalTo(userView.mas_centerX).offset(-5);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            
        }
        if(i==2){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(0);
                make.top.offset(20);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *150/105);
                make.left.equalTo(userView.mas_left).offset(10);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            
        }
        if(i==3){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(20 + kheight*0.6);
                make.right.offset(-60);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *150/105);
                make.left.equalTo(userView.mas_left).offset(-scaleWidth*1.5);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            
        }
        if(i==4){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view).offset(15);
                make.right.offset(-20);
                make.width.offset(khorWidth);
                make.height.offset(kverHeight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *150/105);
                make.right.equalTo(userView.mas_left).offset(-1);
                make.bottom.equalTo(userView.mas_bottom).offset(-10);
            }];
         
        }
        if(i==5){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-15);
                make.left.offset(10);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(spreadWidth * 5 + spreadScaleWidth *4);
                make.height.offset(spreadWidth*150/105.0f);
//                make.height.equalTo(spreadView.mas_width).multipliedBy(1.8);
                make.left.equalTo(userView.mas_right).offset(30);
                make.bottom.equalTo(userView.mas_bottom).offset(0);
            }];
        }
    }
    [self.view layoutIfNeeded];
    self.btnType = normalType;
    [self.view addSubview:self.niuView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.socketServe cutOffSocket];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)initView{
    self.socketServe = [LGSocketServe sharedSocketServe];
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [self.socketServe cutOffSocket];
    self.socketServe.socket.userData = SocketOfflineByServer1;
    [self.socketServe startConnectSocket];
    self.socketServe.delegate = self;
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [self.socketServe sendMessage:@"hello world"];
}

#pragma mark - MZSpreadViewDelegate
- (void)didSelectedWithArr:(NSArray *)imagArr{

    NSLog(@"tag----%@",imagArr);
}

#pragma mark - LGSocketServeDelegate
- (void)requestDataReturn:(id)dict{
    //后台返回数据
    //    [self.playerModel yy_modelSetWithDictionary:dict];
    //    [self.dataArray addObject:self.playerModel];
    NSDictionary *reportHead = [KDJSON objectParseJSONString:dict][@"head"];
    if(self.btnType == prepareType){
        [self.view addSubview:self.countdownLabel];
        [self.countdownLabel enableTimer];
        self.titleArray = @[@"准备"];
        self.btnType = prepareType;
        [self.view addSubview:self.multiHogView];
        //给user赋值userDict
    }
    if([reportHead[@"type"] isEqualToString:@"prepare"]){
        self.titleArray = @[@"不抢庄",@"抢庄"];
        self.countdownLabel.hidden = NO;
        self.btnType = hogType;
        [self.countdownLabel enableTimer];
        [self.view addSubview:self.multiHogView];
    }else if ([reportHead[@"type"] isEqualToString:@"hog"]){
        [self conditionJudge];
    }else if ([reportHead[@"type"] isEqualToString:@"multiply"]){
        [self playerBottomPourJudege];
    }else if ([reportHead[@"type"] isEqualToString:@"deal"]){
        [self showMineCards];
    }
}

#pragma mark - MZCountdownLabelDelegate
- (void)countdowmEnd{
    if(self.btnType == hogType){
        NSLog(@"不抢庄");
    }else if (self.btnType == multipleType){
        NSLog(@"不加倍");
    }else if (self.btnType == prepareType){
        NSLog(@"准备好了");
    }
    [self nextStep];
}

#pragma mark - MZMultipleHogDelegate
- (void)didSelectWithIndexRow:(NSInteger)indexRow andBtnText:(NSString *)btnText andType:(ButtonType)type{
    NSLog(@"tag--%ldtext--%@type--%lu",(long)indexRow,btnText,(unsigned long)type);
    if(self.btnType == hogType){
        NSLog(@"抢庄or不抢庄");
    }else if (self.btnType == multipleType){
        NSLog(@"加倍或者不加倍");
    }else if (self.btnType == prepareType){
        NSLog(@"准备");
    }
    //暂不进行下一步，等待全部准备好
    [self nextStep];
}

- (void)nextStep{
    [self.multiHogView removeFromSuperview];
    self.multiHogView = nil;
    [self.countdownLabel reloadTimer];
    self.countdownLabel.hidden = YES;
    //由上一步来确定下一步怎么走
    if(self.btnType == hogType){
        [self.socketServe sendMessage:@"抢庄不抢庄"];
    }else if (self.btnType == multipleType){
        [self.socketServe sendMessage:@"加不加倍"];
    }else if (self.btnType == prepareType){
        [self.socketServe sendMessage:@"准备好了"];
    }
}

//庄家坐庄条件判断
- (void)conditionJudge{
    
    //所有抢了庄的，需要获取这些人的信息，
    //判断庄是否够积分
    if(!self.playerModel.integral){
        //确认庄主
        //判断限红
        self.btnType = multipleType;
        self.titleArray = @[@"1倍",@"2倍",@"5倍",@"10倍"];
        self.countdownLabel.hidden = NO;
        [self.countdownLabel enableTimer];
        [self.view addSubview:self.multiHogView];
    }
}

//闲家下注判断
- (void)playerBottomPourJudege{
    //玩家下注
    //判断玩家是否够积分<显示相应的倍数>
    [self.socketServe sendMessage:@"开始发牌"];
}

//显示自己的牌
-(void)showMineCards{
   
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    spreadView.spreadArray = @[@"SJ",@"H6",@"D5",@"C8",@"D2"];
//    [self showEachPlayerCards];
    
    //复制给spreadView tag = 10000;spreadArray
    self.titleArray = @[@"",@"",@"",@""];
    self.countdownLabel.hidden = NO;
    [self.countdownLabel enableTimer];
    [self.view addSubview:self.multiHogView];
}

//显示每个玩家的牌
- (void)showEachPlayerCards{
    
    [self OpenBrandAndSendCouncilResult];
    
    //赋值给overlapView  tag = 1000 + i  overlapImageArray
    
    for(int i=0; i<5; i++){
        MZOverlapView *overlapView = (MZOverlapView *)[self.view viewWithTag:1000+i];
        overlapView.overlapImageArray = @[@"CK",@"S2",@"H10",@"C3",@"DJ"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isFirstLoad = YES;
    [self showMineCards];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showEachPlayerCards];
}

//开牌+发送当局结果
- (void)OpenBrandAndSendCouncilResult{
    [self.socketServe sendMessage:@"发送当局结果"];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (MZCountdownLabel *)countdownLabel{
    if(!_countdownLabel){
        _countdownLabel = [[MZCountdownLabel alloc] initWithFrame:CGRectMake(kSCREEN_Width / 2.0 - 30, KSCREEN_HEIGHT / 2.0 - 15, 60, 30)];
        _countdownLabel.delegate = self;
    }
    return _countdownLabel;
}

- (MZMultipleHog *)multiHogView{
    
    if(!_multiHogView){
        _multiHogView = [[MZMultipleHog alloc] initWithFrame:CGRectMake((kSCREEN_Width-self.titleArray.count * 80) / 2.0 , KSCREEN_HEIGHT / 2.0 + 30, self.titleArray.count * 80, 30) andTitleArray:self.titleArray andType:self.btnType];
        _multiHogView.delegate = self;
    }
    return _multiHogView;
}

- (MZcalculateNiuView *)niuView{

    if(!_niuView){
        _niuView = [[MZcalculateNiuView alloc] initWithFrame:CGRectMake((kSCREEN_Width-4 * 80) / 2.0 , KSCREEN_HEIGHT / 2.0 + 30, self.titleArray.count * 80, 30)];
    }
    return _niuView;
}

- (UIImageView *)tableBoardImageView{

    if(!_tableBoardImageView){
    
        _tableBoardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, KSCREEN_HEIGHT)];
        _tableBoardImageView.image = [UIImage imageNamed:@"timg"];
    }
    return _tableBoardImageView;
}

- (void)animateWithView:(UIView *)animateView withStartPoint:(CGPoint)startPoint withControlPoint:(CGPoint)controlPoint withEndPoint:(CGPoint)endPoint{
    [animateView.layer removeAllAnimations];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x , controlPoint.y, endPoint.x, endPoint.y);
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.duration = 0.2;
    animate.fillMode = kCAFillModeForwards;
    animate.repeatCount = 0;
    animate.path = path;
    animate.removedOnCompletion = NO;
    CGPathRelease(path);
    [animateView.layer addAnimation:animate forKey:@"jakillTest"];
}



@end
