//
//  MZEnterGameRoomController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZEnterGameRoomController.h"
#import "MZRoomListController.h"
#import "MZRoomCell.h"
#import "MZRoomListModel.h"
#import "MZPlaygameController.h"
#import "MZGameRoomLeftModel.h"
#import "MZGCDSocketManager.h"
#import "KDJSON.h"
#import "MZLoginModel.h"
#import "MZBalanceModel.h"
@interface MZEnterGameRoomController ()<UITableViewDataSource,UITableViewDelegate,MZRoomListControllerDelegate,MZGCDSocketManagerDelegate>

@property (nonatomic,strong) UITableView *categoriesTableView;
@property (nonatomic,strong) MZRoomListController *roomListController;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *leftDataArray; // 左边数据源
@property (nonatomic, assign) NSInteger selectRow; // 选中的行

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *balanceLabel;

@property (nonatomic, strong) NSMutableDictionary *statusDict;   //状态字典

@end

@implementation MZEnterGameRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MZGCDSocketManager shareInstance].delegate = self;
    [self requestWithAccountBalance];
    [self requestWithCircledGame];
    [self requestWithGameCategary];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
     [self deleteMessage];
}

- (void)deleteMessage{
    [self.dataArray removeAllObjects];
    [self.leftDataArray removeAllObjects];
}

- (void)initView{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    UIImageView *bacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, KSCREEN_HEIGHT)];
    bacImageView.image = [UIImage imageNamed:@"gameRoomBoomImage"];
    [self.view addSubview:bacImageView];
    [self.view addSubview:self.topView];
    self.userLabel.text = [NSString stringWithFormat:@"%@ %@",RDLocalizedString(@"welcome"),loginModel.acc_name];
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",RDLocalizedString(@"balance"),loginModel.acc_bal];
    self.selectRow = 0;
    [self.view addSubview:self.categoriesTableView];
    [self.categoriesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topHeight);
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.19);
    }];
    [self addChildViewController:self.roomListController];
    [self.view addSubview:self.roomListController.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.leftDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZRoomCell *cell = (MZRoomCell *)[tableView dequeueReusableCellWithIdentifier:@"MZRoomCell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.leftDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 86.0 * (kSCREEN_Width * 0.19 - 10)/192.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 105/320.0 * KSCREEN_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectRow = indexPath.row;
//    NSLog(@"-------,%ld  -------%@",indexPath.row,self.dataArray[indexPath.row]);
    if ([self.delegate respondsToSelector:@selector(didDataArray:clickIndexPathRow:andStatusDict:)]) {
        NSArray *tmp;
        if(self.dataArray.count > 0){
            tmp = [[NSArray alloc] initWithArray:self.dataArray[indexPath.row]];
        }else{
            tmp = @[];
        }
        
        [self.delegate didDataArray:tmp?:@[] clickIndexPathRow:indexPath.row andStatusDict:self.statusDict];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    CGFloat kwhscale = 105/320.0;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width * 0.19, kwhscale * KSCREEN_HEIGHT)];
    NSArray *titleArray = @[@"Open",@"Waiting",@"Running",@"Full"];
    CGFloat scaleHeight = 29/2.0 * KSCREEN_HEIGHT/320.0;
    for(int i=0; i<titleArray.count ;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font =[UIFont systemFontOfSize:13];
        btn.tag = i+1;
//        btn.frame = CGRectMake(5, 10 + scaleHeight * i, kSCREEN_Width * 0.25 - 20, scaleHeight);
        [btn setBackgroundImage:[UIImage imageNamed:@"roomChooseFrameBac"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"roomSelectEffect"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(10 + (scaleHeight + 10)* i);
            make.width.offset(27/2.0 * KSCREEN_HEIGHT/320.0);
            make.height.offset(29/2.0 * KSCREEN_HEIGHT/320.0);
        }];
        
        UILabel *titleLabel =[[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.textColor =[UIColor colorWithHexString:@"ffffff"];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.shadowColor = [UIColor colorWithHexString:@"8c4c28"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(5);
            make.centerY.equalTo(btn.mas_centerY).offset(0);
            make.width.offset(kSCREEN_Width * 0.19 - 35);
            make.height.offset(scaleHeight);
        }];
    }

    return footerView;
}

//左侧按钮点击事件
- (void)btnClickAction:(UIButton *)sender{

    sender.selected = !sender.selected;
    [self.statusDict setObject:sender.selected?@"true":@"false" forKey:[NSString stringWithFormat:@"status%ld",sender.tag]];
    if ([self.delegate respondsToSelector:@selector(didDataArray:clickIndexPathRow:andStatusDict:)]) {
        NSArray *tmp;
        if(self.dataArray.count > 0){
            tmp = [[NSArray alloc] initWithArray:self.dataArray[self.selectRow]];
        }else{
        
            tmp = @[];
        }
        
        [self.delegate didDataArray:tmp clickIndexPathRow:self.selectRow andStatusDict:self.statusDict];
    }
}

#pragma mark - MZRoomListControllerDelegate

- (void)didSelectIndexPath:(NSInteger)row{
    NSLog(@"下标为------%ld-------%ld",self.selectRow,row);
    [self requestWithUserEnterRoom:self.dataArray[self.selectRow][row]];
}
#pragma mark  账户余额请求
- (void)requestWithAccountBalance{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":loginModel.acc_name},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
}

#pragma mark  用户进入房间
- (void)requestWithUserEnterRoom:(MZRoomListModel *)roomlistModel{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10000",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"gamecat_id":roomlistModel.gamecat_id,@"gametype_id":roomlistModel.gametype_id,@"game_id":roomlistModel.game_id,@"acc_id":loginModel.acc_id},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
    }];
}

#pragma mark - 限红请求
- (void)requestWithCircledGame{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":loginModel.acc_name,@"acc_type":loginModel.acc_type,@"gametype_id":@"1"},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
    
}

#pragma mark - 限红分类桌台请求
- (void)requestWithGameCategary{
    MZLoginModel *loginModel = [Common getData:@"loginModel"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"13",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":loginModel.acc_name,@"acc_type":loginModel.acc_type,@"gametype_id":@"1",@"gamecat_id":@"2"},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
}

#pragma mark - MZGCDSocketManagerDelegate
- (void)requestDataWithDict:(id)dict{
    NSArray *imageArray = @[@"gameRoomBlueBtn",@"gameRoomPurleBtn",@"gameRoomYellowBtn"];
    NSArray *offsetColorArray = @[@"2a8b9a",@"8c3c96",@"b9651a"];
    NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
    NSLog(@"%@",dictData);
        switch ([[dictData objectForKey:@"command"] longValue]) {
            case 4:{
                //账户余额
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    MZBalanceModel *model = [MZBalanceModel yy_modelWithDictionary:[dictData objectForKey:@"data"]];
                    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",RDLocalizedString(@"balance"),model.acc_bal];
                    [Common setData:model key:@"banlanceModel"];
                }
               
            }
                break;
            case 12:{
                NSLog(@"12------------12");
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    NSArray *dataArray1 = [dictData objectForKey:@"data"];
                    for(int i=0;i<dataArray1.count; i++){
                        MZGameRoomLeftModel *model = [MZGameRoomLeftModel yy_modelWithDictionary:dataArray1[i]];
                        model.imageStr = imageArray[i];
                        model.offsetColorHexStr = offsetColorArray[i];
                        [self.leftDataArray addObject:model];
                    }
                    [self.categoriesTableView reloadData];
                }
            }
                break;
            case 13:{{
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    for (int i=0;i<3;i++){
                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                        NSArray *dataArray1 = [dictData objectForKey:@"data"];
                        for(int j=0;j<dataArray1.count;j++){
                            MZRoomListModel *model = [MZRoomListModel yy_modelWithDictionary:dataArray1[j]];
                            [tempArray addObject:model];
                        }
                        [self.dataArray addObject:tempArray];
                    }
                    self.roomListController.dataSource = [[NSMutableArray alloc] initWithArray:self.dataArray[0]];
                    [self.roomListController.roomListTableView reloadData];
                }
            }
            }
                break;
            case 10000:{
                if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
                    MZPlaygameController *playgameVC = [[MZPlaygameController alloc] init];
                    [self.navigationController pushViewController:playgameVC animated:YES];
                }else{
                    [self showFailureView:[dictData objectForKey:@"remark"]];
                }
                
            }
                break;
            default:
                break;
        }
    
}

- (void)backBtnClickAction:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)categoriesTableView{

    if(!_categoriesTableView){
        _categoriesTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _categoriesTableView.delegate = self;
        _categoriesTableView.dataSource = self;
        
         [_categoriesTableView registerNib:[UINib nibWithNibName:@"MZRoomCell" bundle:nil] forCellReuseIdentifier:@"MZRoomCell"];
        _categoriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoriesTableView.backgroundColor = [UIColor clearColor];
        _categoriesTableView.showsVerticalScrollIndicator = NO;
        [_categoriesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return _categoriesTableView;
}



- (MZRoomListController *)roomListController{

    if(!_roomListController){
    
        _roomListController = [[MZRoomListController alloc]init];
        [self addChildViewController:_roomListController];
        [self.view addSubview:_roomListController.view];
        self.delegate = self.roomListController;
        _roomListController.delegate =self;
        
    }
    return _roomListController;
}

- (NSMutableArray *)dataArray{

    if(!_dataArray){
    
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIView *)topView{

    if(!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, topHeight)];
        UIImageView *topBacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, topHeight)];
        topBacImageView.image = [UIImage imageNamed:@"topBac"];
        [_topView addSubview:topBacImageView];
        [_topView addSubview:self.userLabel];
        [_topView addSubview:self.balanceLabel];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat kbackWidth = 31.5/568.0 *kSCREEN_Width;
//        backBtn.frame = CGRectMake(9, 4, kbackWidth, 31.5/51.5 *kbackWidth);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"check_backLoggy"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(kbackWidth);
            make.height.offset(topHeight);
            make.left.offset(9);
            make.centerY.equalTo(_topView.mas_centerY).offset(-2);
        }];
        [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right).offset(5);
            make.centerY.equalTo(_topView.mas_centerY).offset(-2);
        }];
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(_topView.mas_centerY).offset(-2);
        }];
    }
    return _topView;
}

- (UILabel *)userLabel{

    if(!_userLabel){
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = [UIFont systemFontOfSize:9];
        _userLabel.shadowOffset = CGSizeMake(0, 1);
        _userLabel.text = @"Welcome Username";
        _userLabel.textColor = [UIColor colorWithHexString:@"d1c1ae"];
    }
    return _userLabel;
}

- (UILabel *)balanceLabel{

    if(!_balanceLabel){
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font = [UIFont systemFontOfSize:9];
        _balanceLabel.shadowOffset = CGSizeMake(0, 1);
        _balanceLabel.text = @"Balance：1212121";
        _balanceLabel.textColor = [UIColor colorWithHexString:@"f2e9f8"];
    }
    return _balanceLabel;
}

-(NSMutableArray *)leftDataArray{

    if(!_leftDataArray){
        _leftDataArray = [[NSMutableArray alloc] init];
    }
    return _leftDataArray;
}

- (NSMutableDictionary *)statusDict{

    if(!_statusDict){
        _statusDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"false",@"status1",@"false",@"status2", @"false",@"status3",@"false",@"status4",nil];
    }
    return _statusDict;
}

@end
