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
@interface MZEnterGameRoomController ()<UITableViewDataSource,UITableViewDelegate,MZRoomListControllerDelegate>

@property (nonatomic,strong) UITableView *categoriesTableView;
@property (nonatomic,strong) MZRoomListController *roomListController;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *leftDataArray; // 左边数据源
@property (nonatomic, assign) NSInteger selectRow; // 选中的行

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *balanceLabel;

@end

@implementation MZEnterGameRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//加载数据
- (void)loadData{
    
    for (int i=0;i<5;i++){
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(int j=0;j<5;j++){
            MZRoomListModel *model = [[MZRoomListModel alloc] init];
            model.status = [NSString stringWithFormat:@"status%d",i];
            model.limit = [NSString stringWithFormat:@"limit%d",j];
            [tempArray addObject:model];
        }
        [self.dataArray addObject:tempArray];
    }
}

- (void)initView{

    UIImageView *bacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width, KSCREEN_HEIGHT)];
    bacImageView.image = [UIImage imageNamed:@"gameRoomBoomImage"];
    [self.view addSubview:bacImageView];
    [self.view addSubview:self.topView];
    self.selectRow = 0;
    [self.view addSubview:self.categoriesTableView];
    [self.categoriesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topHeight);
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.19);
    }];
    self.roomListController.dataArray = self.dataArray[0];
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
    if ([self.delegate respondsToSelector:@selector(didDataArray:clickedAtIndexPath:)]) {
        [self.delegate didDataArray:self.dataArray[indexPath.row] clickedAtIndexPath:indexPath];
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


- (void)btnClickAction:(UIButton *)sender{

    
    sender.selected = !sender.selected;
}

#pragma mark - MZRoomListControllerDelegate

- (void)didSelectIndexPath:(NSInteger)row{
    NSLog(@"下标为------%ld-------%ld",self.selectRow,row);
    MZPlaygameController *playgameVC = [[MZPlaygameController alloc] init];
    [self.navigationController pushViewController:playgameVC animated:YES];
}

#pragma mark - 限红请求
- (void)requestWithCircledGame{
  
}

#pragma mark - 限红分类桌台请求
- (void)requestWithGameCategary{
  
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
        [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(_topView.mas_centerY).offset(0);
        }];
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(_topView.mas_centerY).offset(0);
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
//        gameRoomBlueBtn@2x  gameRoomPurleBtn@2x   gameRoomYellowBtn@2x
        NSArray *gradeArray = @[@"Law",@"Medium",@"High"];
        NSArray *interArray = @[@"10-500",@"1000-5000",@"5001-20000"];
        NSArray *imageArray = @[@"gameRoomBlueBtn",@"gameRoomPurleBtn",@"gameRoomYellowBtn"];
        NSArray *offsetColorArray = @[@"2a8b9a",@"8c3c96",@"b9651a"];
        for(int i=0;i<3;i++){
        
            MZGameRoomLeftModel *model = [[MZGameRoomLeftModel alloc] init];
            model.gradeStr = gradeArray[i];
            model.intervalStr = interArray[i];
            model.imageStr = imageArray[i];
            model.offsetColorHexStr = offsetColorArray[i];
            [_leftDataArray addObject:model];
        }
    }
    return _leftDataArray;
}


@end
