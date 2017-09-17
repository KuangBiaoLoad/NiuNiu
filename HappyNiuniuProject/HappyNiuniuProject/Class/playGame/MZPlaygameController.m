

//
//  MZPlaygameController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZPlaygameController.h"
#import "MZGCDSocketManager.h"
#import "MZMultipleHog.h"
#import "MZPlayerModel.h"
#import "KDJSON.h"
#import "MZUserView.h"
#import "MZOverlapView.h"
#import "MZSpreadView.h"
#import "MZLoginModel.h"
#import "MZBuyChips.h"
#import "MZPlayerListModel.h"
#import "MZCardListModel.h"
#import "MZBettingView.h"
#import "MZBackView.h"
#import "MZBalanceModel.h"
@interface MZPlaygameController ()<MZMultipleHogDelegate,MZGCDSocketManagerDelegate,MZBuyChipsDelegate,MZUserViewDelegate,MZBettingViewDelegate,MZBackViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;                //数据源
@property (nonatomic, strong) NSArray *titleArray;                      //弹框数组
@property (nonatomic, strong) UIImageView *tableBoardImageView;         //牌桌
@property (nonatomic, strong) MZPlayerModel *playerModel;               //所有用户模型
@property (nonatomic, strong) MZPlayerListModel *playerListModel;      //单个用户(记录本人的)
@property (nonatomic, strong) MZMultipleHog *multiHogView;              //弹框View
@property (nonatomic, assign) BOOL  isFirstLoad;                          //是否第一次加载
@property (nonatomic, assign) BOOL  spreadIsFirstLoad;
@property (nonatomic, strong) UILabel *boomPourLabel;                   //底注label

@property (nonatomic, assign) CGRect spreadViewOriginalFrame;           //spreadview  原始frame
@property (nonatomic, assign) CGRect multiHogViewOriginalFrame;         //multihogview原始frame
@property (nonatomic, assign) int buyMoney;                       //买入金额

@property (nonatomic, strong) UIButton *colokBtn;                 //倒计时
@property (nonatomic, strong) NSMutableArray *playerlistArray;      //玩家数组
@property (nonatomic, strong) NSMutableArray *cardlistArray;        //牌数组
@property (nonatomic, strong) NSString *recordProcess;              //记录步骤
@property (nonatomic, assign) int betAmount;                  //下注金额
@property (nonatomic, strong) MZBackView *backView;           //返回view
@property (nonatomic, strong) NSString *roomStatus;             //房间状态
@property (nonatomic, strong) UILabel *waitLabel;               //等待显示
@property (nonatomic, strong) MZBuyChips *buyChips;             //买入金额
@property (nonatomic, strong) MZBettingView *bettingView;       //下注
@property (nonatomic, strong) NSArray *oldListArray;            //用户上一次数据
@property (nonatomic, strong) NSArray *newsListArray;           //信用新的数据
@property (nonatomic, assign) BOOL  isUpdateStatus;             //根据状态是否应该刷新
@property (nonatomic, assign) BOOL  addMuiltiView ;  //判断是不是第一次加载

@end

@implementation MZPlaygameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftAndRightView];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self requestWithUserEnterRoom]; //用户进入房间请求
    self.navigationController.navigationBar.hidden = YES;
    [MZGCDSocketManager shareInstance].delegate = self;
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    if(!self.spreadIsFirstLoad && !self.isFirstLoad){
        if(oneselfRow ==10){//表示没有本人
            CGPoint startPoint = CGPointMake(kSCREEN_Width/2.0, KSCREEN_HEIGHT/2.0);
            for(int i=0; i< self.playerlistArray.count; i++){
                if(i== 5){
                    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self animateWithView:spreadView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(spreadView.frame.origin.x + spreadView.frame.size.width/2.0,spreadView.frame.origin.y + spreadView.frame.size.height/2.0)];
                    });
                }else{
                    
                    MZOverlapView *overlapView = (MZOverlapView *)[self.view viewWithTag:1000+i];
                    CGFloat pointx = overlapView.frame.origin.x + overlapView.frame.size.width/2.0 ;
                    CGFloat pointy =overlapView.frame.origin.y + overlapView.frame.size.height/2.0;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC * (i+1))), dispatch_get_main_queue(), ^{
                        [self animateWithView:overlapView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(pointx,pointy)];
                    });
                }
            }
        }else{
            for(int i=0; i< self.playerlistArray.count; i++){//有本人的情况
                CGPoint startPoint = CGPointMake(kSCREEN_Width/2.0, KSCREEN_HEIGHT/2.0);
                if(i==oneselfRow){
                    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self animateWithView:spreadView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(spreadView.frame.origin.x + spreadView.frame.size.width/2.0,spreadView.frame.origin.y + spreadView.frame.size.height/2.0)];
                    });
                }else{
                    int row = i;
                    if(i>oneselfRow){
                        row = i - 1;
                    }
                    MZOverlapView *overlapView = (MZOverlapView *)[self.view viewWithTag:1000+row];
                    CGFloat pointx = overlapView.frame.origin.x + overlapView.frame.size.width/2.0 ;
                    CGFloat pointy =overlapView.frame.origin.y + overlapView.frame.size.height/2.0;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC * (row+1))), dispatch_get_main_queue(), ^{
                        [self animateWithView:overlapView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(pointx,pointy)];
                    });
                    
                }
            }
        }
    }
    if(!self.spreadIsFirstLoad){
        CGPoint startPoint = CGPointMake(kSCREEN_Width/2.0, KSCREEN_HEIGHT/2.0);
        MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animateWithView:spreadView withStartPoint:startPoint withControlPoint:CGPointMake(kSCREEN_Width/2.0 - 80, KSCREEN_HEIGHT/2.0 - 50) withEndPoint:CGPointMake(spreadView.frame.origin.x + spreadView.frame.size.width/2.0,spreadView.frame.origin.y + spreadView.frame.size.height/2.0)];
        });
    }
    
    self.isFirstLoad = YES;
    self.spreadIsFirstLoad = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

//准备开始后spreadviewframe的变化
- (void)recoverOriginalSpreadViewFrame{
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    self.spreadIsFirstLoad  = NO;
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    self.isFirstLoad = YES;
    //    [self showAllPlayerCards];
    for(UITouch *touch in touches){
        if (touch.view != self.backView){
            [self.backView removeFromSuperview];
        }
    }
}

#pragma mark - 网络请求

#pragma mark   用户坐下
- (void)requestWithUserSitDown{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    bool isAutoAddMoney;
    if([[Common getData:@"autoAddMoney"] isEqualToString:@"true"]){
        
        isAutoAddMoney = true;
    }else{
        
        isAutoAddMoney = false;
    }
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10001",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.playerModel.gamecat_id,@"gametype_id":self.playerModel.gametype_id,@"game_id":self.playerModel.game_id,@"acc_id":loginModel.acc_id,@"checkin_amount":[NSString stringWithFormat:@"%d",self.buyMoney],@"auto_add_amount":[NSNumber numberWithBool:isAutoAddMoney]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark  用户下注
- (void)requestWithBetting{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10002",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.playerModel.gamecat_id,@"gametype_id":self.playerModel.gametype_id,@"game_id":self.playerModel.game_id,@"acc_id":loginModel.acc_id,@"bet_amount":[NSString stringWithFormat:@"%d",self.betAmount]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark  用户起身
- (void)requestWithUserGetUp{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10003",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.playerModel.gamecat_id,@"gametype_id":self.playerModel.gametype_id,@"game_id":self.playerModel.game_id,@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark  用户离开房间
- (void)requestWithUserLeaveRoom{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10004",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":self.playerModel.gamecat_id,@"gametype_id":self.playerModel.gametype_id,@"game_id":self.playerModel.game_id,@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark - delegate
#pragma mark  MZMultipleHogDelegate
- (void)didSelectWithBtnText:(NSString *)btnText{
    //准备 下注
    //暂不进行下一步，等待全部准备好
    [self.multiHogView removeFromSuperview];
    [self nextStep:btnText];
}

- (void)nextStep:(NSString *)titleStr{
    if([titleStr isEqualToString:@"准备"]){//准备
        
    }else if ([titleStr isEqualToString:@"下注"]){//下注
        
        self.bettingView.maxMoney = [self.playerListModel.game_maxbet intValue];
        self.bettingView.minMoney = [self.playerListModel.game_minbet intValue];
        [self.view addSubview:self.bettingView];
    }
}

#pragma mark  MZBuyChipsDelegate
- (void)buyChipsWithMoney:(int)money{
    self.buyMoney  = money;
    [self requestWithUserSitDown];//坐下请求
}

#pragma mark  MZBettingViewDelegate
- (void)bettingWithMoney:(int)bettingMoney{
    self.betAmount = bettingMoney;
    [self requestWithBetting]; //下注请求
}
#pragma mark  MZUserViewDelegate
- (void)headImageBtnClick{
    if([self.playerModel.game_maxbuyin intValue] > 0){//如果有收到消息最大最小买入金额 才弹框
        MZBalanceModel *model = [Common getData:@"banlanceModel"];
        self.buyChips.maxMoney = [self.playerModel.game_maxbuyin intValue];
        self.buyChips.minMoney = [self.playerModel.game_minbuyin intValue];
        self.buyChips.totalMoney = [model.acc_bal intValue];
        [self.view addSubview:self.buyChips];
    }
    
}
#pragma mark MZBackViewDelegate
- (void)clickButtonWithTag:(int)btnTag{
    if(!self.roomStatus){  //有消息推送下来的时候才退出
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    switch (btnTag) {
        case 211:{//起身
            
            if([self.roomStatus isEqualToString:@"0"] || [self.roomStatus isEqualToString:@"2"] || [self.roomStatus isEqualToString:@"4"]){
                [self requestWithUserGetUp];
            }else{
                
                //不可以起身
            }
            
        }
            break;
        case 212:{//离开
            [self requestWithUserLeaveRoom];
        }
            break;
        default:
            break;
    }
}

#pragma mark  MZGCDSocketManagerDelegate
- (void)requestDataWithDict:(id)dict{
    NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
    NSLog(@"------------------dictData------\n%@",dictData);
    switch ([[dictData objectForKey:@"command"] longValue]) {
        case 10000:{
            //用户进入房间<游客模式>
            if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 10001:{
            //坐下成功
            if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                [self.buyChips removeFromSuperview];
            }
        }
            break;
        case 20000:{
            //拿到最大最小下注金额<消息下发>
            self.playerModel = [MZPlayerModel yy_modelWithDictionary:[dictData objectForKey:@"room"]];
            [self refreshPageWithMessageData:[dictData objectForKey:@"room"]];
        }
            break;
        case 10002:{//下注
            if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                
            }
        }
            break;
        case 10003:{//起身
            if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                [self.backView removeFromSuperview];
                //                [self .navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 10004:{//离开房间
            if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                [self .navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 根据message消息显示界面
- (void)refreshPageWithMessageData:(NSDictionary *)messageDict{
    
    self.waitLabel.hidden = YES;
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    MZPlayerModel *model = [MZPlayerModel yy_modelWithDictionary:messageDict];
    self.roomStatus = model.room_status;
    if(([model.room_status isEqualToString:@"0"] || [model.room_status isEqualToString:@"2"] || [model.room_status isEqualToString:@"4"])){//如果有下发玩家信息
        self.newsListArray = model.playerList;
        if(![self.newsListArray isEqualToArray:self.oldListArray]){
            [self updateUserInfo:model.playerList];//更新用户信息
        }
    }else if ([model.room_status isEqualToString:@"1"] ||[model.room_status isEqualToString:@"3"]){
        if(!self.isUpdateStatus){
            [self updateUserInfo:model.playerList];//更新用户信息
        }
    }
    if([model.room_status isEqualToString:@"1"]|| [model.room_status isEqualToString:@"3"]){//处于下注倒计时的时候,新用户不能坐下
        for(int i=0; i<6; i++){
            MZUserView *userView = (MZUserView *)[self.view viewWithTag:100 + i];
            userView.whetherAnyone = YES;
        }
    }
    switch ([model.room_status intValue]) {
        case 0:{//准备中<刷新页面>
            self.colokBtn.hidden = YES;
            for(int i=0; i<self.view.subviews.count; i++){
                
                if([self.view.subviews[i] isKindOfClass:[MZMultipleHog class]]){
                    [self.multiHogView removeFromSuperview];
                }
            }
        }
            break;
        case 1:{//下注倒计时
            self.isUpdateStatus = true;
            self.titleArray = @[@"下注"];
            self.multiHogView.imageStr = @"check_boomPourImage";
            
            for(MZPlayerListModel *listModel in self.playerModel.playerList){
                if([listModel.isbanker isEqualToString:@"true"] && [listModel.acc_id isEqualToString:loginModel.acc_id]){
                    self.addMuiltiView = true;
                }
            }
            if(self.addMuiltiView == false && [model.game_betsecond intValue] > 0){
                [self.view addSubview:self.multiHogView];
            }
            
            self.addMuiltiView = true;
            self.colokBtn.hidden = NO;
            [self.colokBtn setTitle:model.game_betsecond forState:UIControlStateNormal];
            if([model.game_betsecond isEqualToString:@"0"]){//倒计时结束 隐藏倒计时按钮 + 更变添加multi状态
                self.addMuiltiView = false;
                self.isUpdateStatus = false;
                self.colokBtn.hidden = YES;
                if(!self.betAmount){
                    self.betAmount = [self.playerListModel.game_minbet intValue];
                    [self.bettingView removeFromSuperview];
                    [self.multiHogView removeFromSuperview];
                    [self requestWithBetting];//用户下注请求
                }
            }
        }
            break;
        case 2:{//下注倒计时截止,下注未满,进入等待状态
            //            [self.view addSubview:self.waitLabel];
            self.waitLabel.hidden = NO;
        }
            break;
        case 3:{//:下注倒计时截止，下注已满，发牌，开牌倒计时
            self.isUpdateStatus = true;
            self.colokBtn.hidden = NO;
            [self.colokBtn setTitle:model.game_opencardsecond forState:UIControlStateNormal];
            if([model.game_opencardsecond isEqualToString:@"0"]){
                self.colokBtn.hidden = YES;
                self.isUpdateStatus = false;
            }
        }
            break;
        case 4:{//下一盘游戏倒计时
            self.colokBtn.hidden = NO;
            [self.colokBtn setTitle:model.game_initiatesecond forState:UIControlStateNormal];
            if([model.game_initiatesecond isEqualToString:@"0"]){
                self.colokBtn.hidden = YES;
                [self recoverOriginalSpreadViewFrame];//更新spreadview
            }
        }
            break;
            
        default:
            break;
    }
    self.oldListArray = model.playerList;
}

static int oneselfRow = 10;   //记录有没有游戏本人
//显示用户信息用户信息
- (void)updateUserInfo:(NSArray *)userArray{
    [self.playerlistArray removeAllObjects];
    self.isFirstLoad = NO;
    oneselfRow = 10;
    for(int i=0;i<6;i++){
        MZUserView *userView = (MZUserView *)[self.view viewWithTag:100 + i];
        userView.userDict = @{@"image":@"headImageNor"};
        userView.isbanker = NO;
    }
    for(int i=0;i<5;i++){
        MZOverlapView * overlapView  = (MZOverlapView *)[self.view viewWithTag:1000 + i];
        overlapView.overlapImageArray = nil;
        overlapView.showNiuImageView.hidden = YES;
    }
    MZSpreadView *spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
    spreadView.spreadArray = nil;
    spreadView.showNiuImageView.hidden = YES;
    MZLoginModel *model = [Common getData:@"loginModel"];
    for(int i=0; i< userArray.count; i++){
        [self.cardlistArray removeAllObjects];
        
        MZPlayerListModel *playlistModel = userArray[i];
        [self.playerlistArray addObject:playlistModel];
        for(MZCardListModel *cardlistModel in playlistModel.card_list){
            [self.cardlistArray addObject:cardlistModel];
        }
        MZUserView *userView = (MZUserView *)[self.view viewWithTag:100 + i];
        MZOverlapView *overlapView;
        MZSpreadView *spreadView;
        if([model.acc_id isEqualToString:playlistModel.acc_id]){//此时游戏玩家为本人
            userView = (MZUserView *)[self.view viewWithTag:105];
            oneselfRow = i;
            spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
            spreadView.spreadArray =self.cardlistArray;
            self.playerListModel = playlistModel;
            if([self.playerModel.room_status isEqualToString:@"4"] && self.cardlistArray.count>1){
                spreadView.shapeStr = playlistModel.shape;
                spreadView.showNiuImageView.hidden = NO;
            }
        }else if(oneselfRow != 10){//  数组中有游戏玩家本人之外的人
            userView = (MZUserView *)[self.view viewWithTag:100 + i-1];
            overlapView  = (MZOverlapView *)[self.view viewWithTag:1000 + i -1];
            overlapView.overlapImageArray = self.cardlistArray;
            if([self.playerModel.room_status isEqualToString:@"3"]){
                overlapView.cardNorImage = @"backCard";
            }else if([self.playerModel.room_status isEqualToString:@"4"] && self.cardlistArray.count>1){
                overlapView.overlapImageArray = self.cardlistArray;
                overlapView.shapeStr = playlistModel.shape;
                overlapView.showNiuImageView.hidden = NO;
            }
        }else{ //
            if(i!=5){
                overlapView = (MZOverlapView *)[self.view viewWithTag:1000 + i];
                overlapView.overlapImageArray = self.cardlistArray;
                if([self.playerModel.room_status isEqualToString:@"3"]){
                    overlapView.cardNorImage = @"backCard";
                }else if([self.playerModel.room_status isEqualToString:@"4"]&& self.cardlistArray.count>1){
                    overlapView.overlapImageArray = self.cardlistArray;
                    overlapView.shapeStr = playlistModel.shape;
                    overlapView.showNiuImageView.hidden = NO;
                }
            }else{
                spreadView = (MZSpreadView *)[self.view viewWithTag:10000];
                spreadView.spreadArray = self.cardlistArray;
                if([self.playerModel.room_status isEqualToString:@"3"]){
                    spreadView.cardNorImage = @"backCard";
                }else if([self.playerModel.room_status isEqualToString:@"4"]&& self.cardlistArray.count>1){
                    spreadView.spreadArray = self.cardlistArray;
                    spreadView.showNiuImageView.hidden = NO;
                    spreadView.shapeStr = playlistModel.shape;
                }
            }
        }
        if([self.roomStatus isEqualToString:@"3"]){
            self.isFirstLoad = NO;
        }else if ([self.roomStatus isEqualToString:@"4"] && self.cardlistArray.count>1){
            [self updateOverlapViewMasonry];
        }
        userView.whetherAnyone = YES;
        if([playlistModel.isbanker isEqualToString:@"true"]){//判断是不是庄家
            userView.isbanker = YES;
            userView.userDict = @{@"image":@"UserHeadImage",@"user":playlistModel.acc_name,@"gold":playlistModel.banker_amount};
        }else{
            userView.userDict = @{@"image":@"UserHeadImage",@"user":playlistModel.acc_name,@"gold":playlistModel.bet_amount};
        }
    }
    //如果本人已经坐下 不能再点击坐下按钮
    if(oneselfRow != 10){
        for(int i=0; i<6; i++){
            MZUserView *userView = (MZUserView *)[self.view viewWithTag:100 + i];
            userView.whetherAnyone = YES;
        }
    }
}


#pragma mark - UIButtonClickAction

- (void)backBtnClickAction:(UIButton *)sender{
    if(oneselfRow==10){
        self.backView.gotUpbtn.enabled = NO;
    }
    [self.view addSubview:self.backView];
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
    leftBoomImageView.image = [UIImage imageNamed:RDLocalizedString(@"check_bottomPouringen")];
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
    
    [self.view addSubview:self.waitLabel];
    self.waitLabel.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.colokBtn];
    self.colokBtn.hidden = YES;
    MZSpreadView *spreadView = [[MZSpreadView alloc] init];
    spreadView.showNiuImageView.hidden = YES;
    spreadView.tag = 10000;
    CGFloat spreadWidth = kSCREEN_Width/10.0f;
    CGFloat spreadScaleWidth = 2;
    [spreadView spreadWidth:spreadWidth withScaleWidth:spreadScaleWidth];
    //根据屏幕设置宽高比
    CGFloat kwidth = kSCREEN_Width/4.66f;
    CGFloat kheight = kwidth/2.0f;
    CGFloat khorWidth = kwidth/2.0f;
    CGFloat kverHeight = khorWidth * 1.6f;
    for(int i=0; i<6;i++){
        MZUserView *userView = [[MZUserView alloc] init];
        userView.tag = 100+i;
        directionType dirType;
        userView.delegate = self;
        dirType = (i==0 ||i==4)?verticalDirectionType:horizontalDirectionType;
        [userView userDirection:dirType];
        [userView createUserCoradius:kheight];
        MZOverlapView *overlapView = [[MZOverlapView alloc] init];
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
        }
    }
    [self.colokBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.offset(49);
        make.width.offset(46);
    }];
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.centerY.equalTo(self.view.mas_centerY).offset(0);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (MZMultipleHog *)multiHogView{
    
    if(!_multiHogView){
        _multiHogView = [[MZMultipleHog alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 - 35 , self.view.frame.size.height / 2.0 +  35, 70, 31) andTitleArray:self.titleArray];
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

- (UIButton *)colokBtn{
    
    if(!_colokBtn){
        
        _colokBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colokBtn setBackgroundImage:[UIImage imageNamed:@"check_alarmClock"] forState:UIControlStateNormal];
        _colokBtn.titleLabel.font = [UIFont systemFontOfSize:27];
        [_colokBtn setTitle:@"10" forState:UIControlStateNormal];
        [_colokBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _colokBtn.adjustsImageWhenHighlighted = NO;
    }
    return _colokBtn;
}

-(NSMutableArray *)playerlistArray{
    
    if(!_playerlistArray){
        
        _playerlistArray = [[NSMutableArray alloc] init];
    }
    return _playerlistArray;
}

-(NSMutableArray *)cardlistArray{
    
    if(!_cardlistArray){
        
        _cardlistArray = [[NSMutableArray alloc] init];
    }
    return _cardlistArray;
}
- (MZBackView *)backView{
    
    if(!_backView){
        
        _backView = [[MZBackView alloc] initWithFrame:CGRectMake(10, 5, 100, 100)];
        _backView.deleagte = self;
    }
    return _backView;
}
- (UILabel *)waitLabel{
    
    if(!_waitLabel){
        
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.text = RDLocalizedString(@"waiting");
        _waitLabel.textColor = [UIColor greenColor];
        _waitLabel.font = [UIFont systemFontOfSize:15];
    }
    return _waitLabel;
}
-(MZPlayerListModel *)playerListModel{
    
    if(!_playerListModel){
        _playerListModel = [[MZPlayerListModel alloc] init];
    }
    return _playerListModel;
}

-(MZPlayerModel *)playerModel{
    
    if(!_playerModel){
        
        _playerModel = [[MZPlayerModel alloc] init];
    }
    return _playerModel;
}
- (MZBuyChips *)buyChips{
    
    if(!_buyChips){
        _buyChips = [[MZBuyChips alloc] initWithFrame:self.view.frame];
        _buyChips.delegate = self;
    }
    return _buyChips;
}
- (MZBettingView *)bettingView{
    
    if(!_bettingView){
        _bettingView = [[MZBettingView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - 125 , self.view.frame.size.height - 104 -30, 250, 104)];
    }
    return _bettingView;
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
