//
//  MZPlaygameController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZPlaygameController.h"
#import "MZGCDSocketManager.h"
#import "MZCountdownView.h"
#import "MZMultipleHog.h"
#import "MZPlayerModel.h"
#import "KDJSON.h"
#import "MZUserView.h"
#import "MZOverlapView.h"
#import "MZSpreadView.h"
#import "MZLoginModel.h"
@interface MZPlaygameController ()<MZCountdownViewDelegate,MZMultipleHogDelegate,MZGCDSocketManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;                //数据源
@property (nonatomic, strong) NSArray *titleArray;                      //弹框数组
@property (nonatomic, strong) UIImageView *tableBoardImageView;         //牌桌
@property (nonatomic, strong) MZCountdownView *countdownView;         //倒计时显示
@property (nonatomic, strong) MZPlayerModel *playerModel;               //用户模型
@property (nonatomic, strong) MZMultipleHog *multiHogView;              //弹框View
@property (nonatomic, assign) ButtonType btnType;                       //枚举(准备，是否抢庄，倍数)
@property (nonatomic, assign) BOOL  isFirstLoad;                          //是否第一次加载
@property (nonatomic, assign) BOOL  spreadIsFirstLoad;
@property (nonatomic, strong) UILabel *boomPourLabel;                   //底注label

@property (nonatomic, assign) CGRect spreadViewOriginalFrame;           //spreadview  原始frame
@property (nonatomic, assign) CGRect multiHogViewOriginalFrame;         //multihogview原始frame
@end

@implementation MZPlaygameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftAndRightView];
    [self createView];
    [self requestWithUserEnterRoom]; //用户进入房间请求
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MZGCDSocketManager shareInstance].delegate = self;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    if(!self.spreadIsFirstLoad && !self.isFirstLoad){
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
    if(!self.spreadIsFirstLoad){
        CGPoint startPoint = CGPointMake(kSCREEN_Width/2.0, KSCREEN_HEIGHT/2.0);
        MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            spreadView.hidden = NO;
            [self animateWithView:spreadView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(spreadView.frame.origin.x + spreadView.frame.size.width/2.0,spreadView.frame.origin.y + spreadView.frame.size.height/2.0)];
        });
    }
    
    self.isFirstLoad = YES;
    self.spreadIsFirstLoad = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self deleteViewMeaasge];
    
}

-(void)deleteViewMeaasge{
    [self.countdownView reloadTimer];
    self.countdownView = nil;
    [self.countdownView removeFromSuperview];
}

- (void)nextStep{
    
    self.isFirstLoad = NO;
    self.spreadIsFirstLoad = NO;
    [self.multiHogView removeFromSuperview];
    self.multiHogView = nil;
    [self.countdownView reloadTimer];
    self.countdownView.hidden = YES;
    [self recoverOriginalSpreadViewFrame];
    //由上一步来确定下一步怎么走
    if(self.btnType == bottomPourType){
        //        [[LGSocketServe sharedSocketServe] sendMessage:@"下注"];
    }else if (self.btnType == multipleType){
        //        [[LGSocketServe sharedSocketServe] sendMessage:@"加不加倍"];
    }else if (self.btnType == prepareType){
        //        [[LGSocketServe sharedSocketServe] sendMessage:@"准备好了"];
    }
}

//闲家下注判断
- (void)playerBottomPourJudege{
    //玩家下注
    //判断玩家是否够积分<显示相应的倍数>
    //    [[LGSocketServe sharedSocketServe] sendMessage:@"开始发牌"];
}



//显示自己的牌
-(void)showAllPlayerCards{
    
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    spreadView.spreadArray = @[@"SJ",@"H6",@"D5",@"C8",@"D2"];
    //复制给spreadView tag = 10000;spreadArray
    self.titleArray = @[@"准备"];
    self.countdownView.hidden = NO;
    [self.countdownView enableTimer];
    self.multiHogView.imageStr = @"check_prepare";
    [self.view addSubview:self.multiHogView];
    [self.view addSubview:self.countdownView];
    [self updateOverlapViewMasonry];
    for(int i=0; i<5; i++){
        MZOverlapView *overlapView = (MZOverlapView *)[self.view viewWithTag:1000+i];
        overlapView.showNiuImageView.hidden = NO;
        overlapView.overlapImageArray = @[@"CK",@"S2",@"H10",@"C3",@"DJ"];
    }
    
}

//准备开始后spreadviewframe的变化
- (void)recoverOriginalSpreadViewFrame{
    
    self.titleArray = @[@"1倍",@"2倍",@"5倍",@"10倍"];
    self.multiHogView.imageStr = @"check_double";
    [self.view addSubview:self.multiHogView];
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    self.self.spreadIsFirstLoad  = NO;
    spreadView.updateImageWdith = (self.spreadViewOriginalFrame.size.width-8)/5.0;
    [spreadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-11);
        make.width.equalTo(@(self.spreadViewOriginalFrame.size.width));
        make.height.equalTo(@(self.spreadViewOriginalFrame.size.height));
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
    }];
}

//开牌后spreadView的变化
- (void)updateOverlapViewMasonry{
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    self.spreadIsFirstLoad  = NO;
    spreadView.showNiuImageView.hidden = NO;
    self.spreadViewOriginalFrame = spreadView.frame;
    CGFloat kspreadScale = self.spreadViewOriginalFrame.size.width / self.spreadViewOriginalFrame.size.height;
    spreadView.updateImageWdith = (self.spreadViewOriginalFrame.size.width *0.6-8)/5.0;
    [spreadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.width.equalTo(@(self.spreadViewOriginalFrame.size.width *0.6));
        make.height.equalTo(@(self.spreadViewOriginalFrame.size.width *0.6 / kspreadScale));
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
    }];
    
    self.multiHogViewOriginalFrame = self.multiHogView.frame;
    [self.multiHogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-5);
        make.width.offset(self.multiHogViewOriginalFrame.size.width);
        make.height.offset(self.multiHogViewOriginalFrame.size.height);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isFirstLoad = YES;
    [self showAllPlayerCards];
}

#pragma mark - 网络请求
#pragma mark 反回玩家余额，游戏成绩
- (void)returnPlayerBalance{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"21",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"game_wl":@"1122",@"game_payrate":@"1",@"game_commamt":@"2",@"game_comm":@"",@"game_betamt":@"",@"game_card":@"",@"game_mode":@"",@"gamecat_id":self.roomListModel.gamecat_id,@"gametype_id":self.roomListModel.gametype_id,@"game_id":self.roomListModel.game_id,@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark - 用户进入房间
- (void)requestWithUserEnterRoom{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10000",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.roomListModel.gamecat_id,@"gametype_id":self.roomListModel.gametype_id,@"game_id":self.roomListModel.game_id,@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark  - 用户坐下
- (void)requestWithUserSitDown{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10001",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.roomListModel.gamecat_id,@"gametype_id":self.roomListModel.gametype_id,@"game_id":self.roomListModel.game_id,@"acc_id":loginModel.acc_id,@"checkin_amount":@"1122"},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark - MZCountdownLabelDelegate
- (void)countdowmEnd{
    if(self.btnType == bottomPourType){
        NSLog(@"下注");
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
    if(self.btnType == bottomPourType){
        NSLog(@"下注");
    }else if (self.btnType == multipleType){
        NSLog(@"加倍或者不加倍");
    }else if (self.btnType == prepareType){
        NSLog(@"准备");
    }
    //暂不进行下一步，等待全部准备好
    [self nextStep];
}

#pragma mark - MZGCDSocketManagerDelegate
- (void)requestDataWithDict:(id)dict{
    NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
        switch ([[dictData objectForKey:@"command"] longValue]) {
            case 21:{
                //发送当局结果后的回调
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                
                }
                self.titleArray = @[@"准备"];
                self.countdownView.hidden = NO;
                [self.countdownView enableTimer];
                self.multiHogView.imageStr = @"check_prepare";
                [self.view addSubview:self.multiHogView];
            }
                break;
            case 10000:{
                //用户进入房间<游客模式>
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    //点击坐下 (弹出下注框)
                }else{
                
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
                break;
            case 10001:{
                //准备发牌
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    
                }
            }
                break;
            default:
                break;
        }
}


#pragma mark - UIButtonClickAction

- (void)backBtnClickAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createLeftAndRightView{
    [self.view addSubview:self.tableBoardImageView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat kbackWidth = 51.5/568.0 *kSCREEN_Width;
    backBtn.frame = CGRectMake(9, 4, kbackWidth, 31.5/51.5 *kbackWidth);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"check_backLoggy"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIImageView *rightImageview = [[UIImageView alloc] init];
    rightImageview.image = [UIImage imageNamed:@"check_bottomFrame"];
    
    UIImageView *leftBoomImageView = [[UIImageView alloc] init];
    leftBoomImageView.image = [UIImage imageNamed:@"check_bottomPouring"];
    [self.view addSubview:rightImageview];
    [self.view addSubview:leftBoomImageView];
    [self.view addSubview:self.boomPourLabel];
    
    [rightImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-23);
        make.top.offset(4.5);
        make.width.offset(76);
        make.height.offset(18);
    }];
    [leftBoomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightImageview.mas_left).offset(0);
        make.centerY.equalTo(rightImageview.mas_centerY).offset(0);
    }];
    [self.boomPourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBoomImageView.mas_right).offset(2);
        make.centerY.equalTo(leftBoomImageView.mas_centerY).offset(0);
    }];
    
}
- (void)createView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    NSArray *typeArray = @[@(verticalDirectionType),@(horizontalDirectionType),@(horizontalDirectionType),@(horizontalDirectionType),@(verticalDirectionType),@(horizontalDirectionType)];
    NSArray *imageArray = @[@"UserHeadImage",@"UserHeadImage",@"UserHeadImage",@"UserHeadImage",@"UserHeadImage",@"UserHeadImage"];
    NSArray *userNameArray = @[@"kuangbiao",@"世界",@"helloworld",@"objective-c",@"易联支付",@"欢乐牛牛"];
    NSArray *goldArray = @[@"200.03万",@"12.09万",@"2.34万",@"1000.75万",@"34.78万",@"678.78万"];
    MZSpreadView *spreadView = [[MZSpreadView alloc] init];
    spreadView.showNiuImageView.hidden = YES;
    spreadView.tag = 10000;
    spreadView.hidden = YES;
    CGFloat spreadWidth = kSCREEN_Width/10.0f;
    CGFloat spreadScaleWidth = 2;
    [spreadView spreadWidth:spreadWidth withScaleWidth:spreadScaleWidth];
    //根据屏幕设置宽高比
    CGFloat kwidth = kSCREEN_Width/4.66f;
    CGFloat kheight = kwidth/2.0f;
    CGFloat khorWidth = kwidth/2.0f;
    CGFloat kverHeight = khorWidth * 1.6f;
    for(int i=0; i<6;i++){
        UILabel *hogLabel = [[UILabel alloc] init];
        hogLabel.tag = 500+i;
        hogLabel.text = @"X10";
        hogLabel.hidden = YES;
        hogLabel.font = [UIFont systemFontOfSize:18];
        hogLabel.shadowOffset = CGSizeMake(0, 1);
        hogLabel.shadowColor = [UIColor colorWithHexString:@"FFD200"];
//        hogLabel.hidden = YES;
        hogLabel.textColor = [UIColor colorWithHexString:@"6CFF00"];
        [self.view addSubview:hogLabel];
        MZUserView *userView = [[MZUserView alloc] init];
        userView.tag = 100+i;
        directionType dirType;
        dirType = (i==0 ||i==4)?verticalDirectionType:horizontalDirectionType;
        [userView userDirection:dirType withImageUrl:imageArray[i] withUserNameStr:userNameArray[i] withGoldStr:goldArray[i]];
        [userView createUserCoradius:kheight];
        MZOverlapView *overlapView = [[MZOverlapView alloc] init];
        overlapView.hidden = YES;
        overlapView.tag = 1000 + i;
        CGFloat overlapWidth = kSCREEN_Width /6.0;
        CGFloat scaleWidth = overlapWidth/6.0;
        [overlapView overlapWidth:scaleWidth * 2 withScaleWidth:scaleWidth];
        [self.view addSubview:userView];
        [self.view addSubview:overlapView];
        [self.view addSubview:spreadView];
        overlapView.showNiuImageView.hidden = YES;
        if(i==0){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(7.5);
                make.centerY.equalTo(self.view).offset(0);
                make.width.offset(khorWidth);
                make.height.offset(kverHeight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *78.5/58.5);
                make.left.equalTo(userView.mas_right).offset(1);
                make.centerY.equalTo(userView.mas_centerY).offset(0);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.bottom.equalTo(userView.mas_bottom).offset(-3);
                make.left.equalTo(userView.mas_right).offset(3);
            }];
        }
        if(i==1){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(67.5);
                make.top.offset(26);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *78.5/58.5);
                make.left.equalTo(userView.mas_centerX).offset(-5);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.top.equalTo(userView.mas_bottom).offset(0);
                make.left.equalTo(userView.mas_left).offset(25);
            }];
            
        }
        if(i==2){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view).offset(0);
                make.top.offset(7.5);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *78.5/58.5);
                make.left.equalTo(userView.mas_left).offset(40);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.top.equalTo(userView.mas_bottom).offset(0);
                make.left.equalTo(userView.mas_left).offset(0);
            }];
            
        }
        if(i==3){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(26);
                make.right.offset(-22.5);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *78.5/58.5);
                make.left.equalTo(userView.mas_left).offset(-scaleWidth*3.7);
                make.top.equalTo(userView.mas_bottom).offset(1);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.top.equalTo(userView.mas_bottom).offset(0);
                make.left.equalTo(overlapView.mas_right).offset(5);
            }];
            
        }
        if(i==4){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view).offset(0);
                make.right.offset(-10.5);
                make.width.offset(khorWidth);
                make.height.offset(kverHeight);
            }];
            [overlapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(overlapWidth);
                make.height.offset(scaleWidth * 2 *78.5/58.5);
                make.right.equalTo(userView.mas_left).offset(-1);
                make.centerY.equalTo(userView.mas_centerY).offset(0);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.bottom.equalTo(userView.mas_bottom).offset(0);
                make.right.equalTo(userView.mas_left).offset(-2);
            }];
            
        }
        if(i==5){
            [userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-29.5);
                make.left.offset(30.5);
                make.width.offset(kwidth);
                make.height.offset(kheight);
            }];
            [spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(spreadWidth * 5 + spreadScaleWidth *4);
                make.height.offset(spreadWidth*78.5/58.5);
                //                make.left.equalTo(userView.mas_right).offset(5);
                make.centerX.equalTo(self.view.mas_centerX).offset(20);
                make.bottom.equalTo(self.view.mas_bottom).offset(-11);
            }];
            [hogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(35);
                make.height.offset(20);
                make.bottom.equalTo(userView.mas_top).offset(-2);
                make.right.equalTo(userView.mas_right).offset(-5);
            }];
        }
    }
    [self.view layoutIfNeeded];
    self.btnType = prepareType;
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (MZCountdownView *)countdownView{
    if(!_countdownView){
        _countdownView = [[MZCountdownView alloc] initWithFrame:CGRectMake(kSCREEN_Width / 2.0 - 23, KSCREEN_HEIGHT / 2.0 - 25, 46, 49)];
        _countdownView.delegate = self;
    }
    return _countdownView;
}

- (MZMultipleHog *)multiHogView{
    
    if(!_multiHogView){
        _multiHogView = [[MZMultipleHog alloc] initWithFrame:CGRectMake((kSCREEN_Width-self.titleArray.count * 50/568.0 *kSCREEN_Width - (self.titleArray.count - 1)*kmultihogviewScaleWidth) / 2.0 + 15 , KSCREEN_HEIGHT / 2.0 + 50/568.0 *kSCREEN_Width * 55 /108.0 + 10, self.titleArray.count * 50/568.0 *kSCREEN_Width + (self.titleArray.count - 1)*kmultihogviewScaleWidth, 50/568.0 *kSCREEN_Width * 55 /108.0) andTitleArray:self.titleArray andType:self.btnType];
        _multiHogView.delegate = self;
    }
    return _multiHogView;
}


- (UIImageView *)tableBoardImageView{
    
    if(!_tableBoardImageView){
        
        _tableBoardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, KSCREEN_HEIGHT)];
        _tableBoardImageView.image = [UIImage imageNamed:@"check_desktopBac"];
    }
    return _tableBoardImageView;
}

- (UILabel *)boomPourLabel{
    
    if(!_boomPourLabel){
        _boomPourLabel = [[UILabel alloc] init];
        _boomPourLabel.textColor = [UIColor yellowColor];
        _boomPourLabel.text = @"3";
        _boomPourLabel.font = [UIFont systemFontOfSize:18];
    }
    return _boomPourLabel;
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
