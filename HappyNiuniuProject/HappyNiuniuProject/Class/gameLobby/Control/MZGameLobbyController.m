//
//  MZGameLobbyController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZGameLobbyController.h"
#import "MZEnterGameRoomController.h"
#import "MZLobbySView.h"
#import "MZSettingController.h"
#import "KDJSON.h"
#import "MZlocalizableContoller.h"
#import "MZBalanceModel.h"
#import "MZGCDSocketManager.h"
#import "MZGameRuleView.h"
#import "MZMessageView.h"
#import "MZSettingView.h"
#import "MZLoginModel.h"
#import "MZMessageModel.h"
#import "MZGameTypeModel.h"
@interface MZGameLobbyController ()<MZLobbySViewDelegate,MZGCDSocketManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong)MZLobbySView *lobbyScrollView;
@property (weak, nonatomic) IBOutlet UILabel *playLoggyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *playruleBtn;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nicknameBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *gameTypeArray;
@end

@implementation MZGameLobbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MZGCDSocketManager shareInstance].delegate = self;
    [self requestWithAccountBalance];
    [self requestWithGameCategory];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self deleteMessage];
}

- (void)deleteMessage{
    [self.messageArray removeAllObjects];
}

- (void)initView{
//    self.title = @"游戏大厅";
    //计算scrollerView的位置
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    self.headImageBtn.adjustsImageWhenHighlighted = NO;
    [self.balanceBtn setTitle:loginModel.acc_bal forState:UIControlStateNormal];
    [self.nicknameBtn setTitle:[NSString stringWithFormat:@"IP %@",loginModel.acc_nickname] forState:UIControlStateNormal];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",RDLocalizedString(@"balance"),loginModel.acc_bal];
    self.playLoggyLabel.text = RDLocalizedString(@"gamesLobby");
    self.welcomeLabel.text = [NSString stringWithFormat:@"%@ %@",RDLocalizedString(@"welcome"),loginModel.acc_name];
    [self.playruleBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"playrule")] forState:UIControlStateNormal];
    [self.noticeBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"notice")] forState:UIControlStateNormal];
    [self.setBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"set")] forState:UIControlStateNormal];
   
    
}

- (void)lobbyViewDidSelectWithIndexTag:(NSInteger)indexTag{
    NSLog(@"----%ld---",(long)indexTag);
    MZEnterGameRoomController *roomVC = [[MZEnterGameRoomController alloc] initWithNibName:@"MZEnterGameRoomController" bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];
}
#pragma mark - UIButtonClickAction
#pragma mark  游戏规则按钮点击事件
- (IBAction)gameRuleClickAction:(id)sender {
    [self requestWithGetGameRule];
}

#pragma mark 消息按钮点击事件
- (IBAction)messageeClickAction:(id)sender {
    [self.messageArray removeAllObjects];
    [self requestWithMessage];
}
#pragma mark 设置按钮点击事件
- (IBAction)setClickAction:(id)sender {
    
    MZSettingView *setView = [[MZSettingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:setView];
//    MZSettingController *setVC = [[MZSettingController alloc] initWithNibName:@"MZSettingController" bundle:nil];
//    [self presentViewController:setVC animated:YES completion:nil];
}

#pragma mark - 网络请求
#pragma mark  账户余额请求
- (void)requestWithAccountBalance{
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[Common getData:@"acc_name"]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
}

#pragma mark  消息请求
- (void)requestWithMessage{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[Common getData:@"acc_name"]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
    
}

#pragma mark - 游戏规则
- (void)requestWithGetGameRule{
     MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"41",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
    
}

#pragma mark  游戏种类请求
- (void)requestWithGameCategory{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"11",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[Common getData:@"acc_name"],@"acc_type":loginModel.acc_type},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
}

-(void)requestDataWithDict:(id)dict{
    
    //根据dict返回的数据类型判断
    NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
    NSLog(@"%@",dictData);
    if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
        switch ([[dictData objectForKey:@"command"] longValue]) {
            case 4:{
                //账户余额
                NSLog(@"什么鬼");
                MZBalanceModel *model = [MZBalanceModel yy_modelWithDictionary:[dictData objectForKey:@"data"]];
                self.balanceLabel.text = model.acc_bal;
                //            [self.balanceLabel layoutIfNeeded];
                
            }
                break;
            case 5:{
            
                NSArray *messageData = [dictData objectForKey:@"data"];
                for(int i=0; i<messageData.count; i++){
                    MZMessageModel *model = [MZMessageModel yy_modelWithDictionary:messageData[i]];
                    [self.messageArray addObject:model];
                }
                MZMessageView *messageView = [[MZMessageView alloc] initWithFrame:self.view.frame];
                messageView.messageArray = self.messageArray;
                [self.view addSubview:messageView];
            }
                
                break;
            case 11:{
                [_lobbyScrollView removeFromSuperview];
                [self.gameTypeArray removeAllObjects];
                NSArray *typeArray = [dictData objectForKey:@"data"];
                for(NSDictionary *tempDict in typeArray){
                    MZGameTypeModel *model = [MZGameTypeModel yy_modelWithDictionary:tempDict];
                    [self.gameTypeArray addObject:model];
                }
                //顶部bac的高度 kscreenwidth*7/142
                CGFloat  topheight = kSCREEN_Width * 7 / 142.0;
                //顶部bac的高度kscreenwidth * 57.5/320
                CGFloat  boomHeight = KSCREEN_HEIGHT * 57.5/320;
                //scrollerView左边距离 kscreenwidth * 113/568
                CGFloat kleftScale = 31 * (KSCREEN_HEIGHT - topheight)/59.0 * 0.68;
                //距离top高度
                CGFloat kdistopHeight = KSCREEN_HEIGHT * 35 /320.0;
                
                CGFloat lobbyHeight = KSCREEN_HEIGHT - topheight - kdistopHeight * 2 - boomHeight;
                _lobbyScrollView = [[MZLobbySView alloc]initWithFrame:CGRectMake(kleftScale, kdistopHeight + topheight, kSCREEN_Width - kleftScale - 15, lobbyHeight) data:self.gameTypeArray];
                _lobbyScrollView.delegate = self;
                [self.view addSubview:_lobbyScrollView];
                NSLog(@"执行成功");
            }
                break;
            case 41:{
            
                NSDictionary *dataDict = [dictData objectForKey:@"data"];
                MZGameRuleView *ruleView = [[MZGameRuleView alloc] initWithFrame:self.view.frame];
                ruleView.contentStr = [dataDict objectForKey:@"ruleen"];
                [self.view addSubview:ruleView];
            }
                break;
            default:
                break;
        }
    }
}

- (NSMutableArray *)messageArray{

    if(!_messageArray){
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}

-(NSMutableArray *)gameTypeArray{

    if(!_gameTypeArray){
    
        _gameTypeArray = [[NSMutableArray alloc] init];
    }
    return _gameTypeArray;
}


@end
