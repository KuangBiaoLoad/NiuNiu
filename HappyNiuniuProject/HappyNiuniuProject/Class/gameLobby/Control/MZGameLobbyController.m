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
@interface MZGameLobbyController ()<MZLobbySViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong)MZLobbySView *lobbyScrollView;
@property (weak, nonatomic) IBOutlet UILabel *playLoggyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *playruleBtn;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@end

@implementation MZGameLobbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self createNavgationBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initView{
//    self.title = @"游戏大厅";
    //计算scrollerView的位置
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ 12345678",RDLocalizedString(@"balance")];
    self.playLoggyLabel.text = RDLocalizedString(@"gamesLobby");
    self.welcomeLabel.text = [NSString stringWithFormat:@"%@ username",RDLocalizedString(@"welcome")];
    [self.playruleBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"playrule")] forState:UIControlStateNormal];
    [self.noticeBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"notice")] forState:UIControlStateNormal];
    [self.setBtn setBackgroundImage:[UIImage imageNamed:RDLocalizedString(@"set")] forState:UIControlStateNormal];
    //顶部bac的高度 kscreenwidth*7/142
    CGFloat  topHeight = kSCREEN_Width * 7 / 142.0;
    //顶部bac的高度kscreenwidth * 57.5/320
    CGFloat  boomHeight = KSCREEN_HEIGHT * 57.5/320;
    //scrollerView左边距离 kscreenwidth * 113/568
    CGFloat kleftScale = 31 * (KSCREEN_HEIGHT - topHeight)/59.0 * 0.68;
    //距离top高度
    CGFloat kdistopHeight = KSCREEN_HEIGHT * 35 /320.0;
    
    CGFloat lobbyHeight = KSCREEN_HEIGHT - topHeight - kdistopHeight * 2 - boomHeight;
    _lobbyScrollView = [[MZLobbySView alloc]initWithFrame:CGRectMake(kleftScale, kdistopHeight + topHeight, kSCREEN_Width - kleftScale - 15, lobbyHeight) data:@[@"",@"",@"",@"",@"",@"",@""]];
    _lobbyScrollView.delegate = self;
    [self.view addSubview:_lobbyScrollView];
    
}

- (void) createNavgationBarItem{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 32)];
//    imageView.backgroundColor = [UIColor greenColor];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
//    self.navigationItem.leftBarButtonItem = barItem;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor =[UIColor greenColor];
    
//    UILabel  *uesrLabel = [[UILabel alloc] init];
//    uesrLabel.text = @"Welcome： username";
////    uesrLabel.frame = CGRectMake(20, 0, 150, 32);
//    uesrLabel.font = [UIFont systemFontOfSize:14];
//    uesrLabel.textColor = [UIColor whiteColor];
//    [imageView addSubview:uesrLabel];
//    [uesrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(10);
//        make.centerY.equalTo(@0);
//    }];
//    
//    UILabel  *balanceLabel = [[UILabel alloc] init];
//    balanceLabel.text = @"Balance: 123490";
////    balanceLabel.frame = CGRectMake(self.view.frame.size.width - 170, 0, 150, 32);
//    balanceLabel.font = [UIFont systemFontOfSize:14];
//    balanceLabel.textColor = [UIColor whiteColor];
//    [imageView addSubview:balanceLabel];
//    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-10);
//        make.centerY.equalTo(@0);
//    }];
//    UIBarButtonItem* negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       
//                                                                                    target:nil action:nil];
//    negativeSpacer.width = -20;
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, barItem,nil]];
    
}
- (void)lobbyViewDidSelectWithIndexTag:(NSInteger)indexTag{
    NSLog(@"----%ld---",(long)indexTag);
    MZEnterGameRoomController *roomVC = [[MZEnterGameRoomController alloc] initWithNibName:@"MZEnterGameRoomController" bundle:nil];
    [self.navigationController pushViewController:roomVC animated:YES];
}
#pragma mark - UIButtonClickAction
#pragma mark  游戏规则按钮点击事件
- (IBAction)gameRuleClickAction:(id)sender {
    
}

#pragma mark 金币充值按钮点击事件
- (IBAction)goldRechargeClickAction:(id)sender {
    
}
#pragma mark 设置按钮点击事件
- (IBAction)setClickAction:(id)sender {
    MZSettingController *setVC = [[MZSettingController alloc] initWithNibName:@"MZSettingController" bundle:nil];
    [self presentViewController:setVC animated:YES completion:nil];
}

#pragma mark - 网络请求
#pragma mark  账户余额请求
- (void)requestWithAccountBalance{
  
}

#pragma mark  消息请求
- (void)requestWithMessage{
 
}

#pragma mark  游戏种类请求
- (void)requestWithGameCategory{

 
}

@end
