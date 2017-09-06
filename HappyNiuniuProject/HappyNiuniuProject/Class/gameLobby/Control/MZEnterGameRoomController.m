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
@interface MZEnterGameRoomController ()<UITableViewDataSource,UITableViewDelegate,MZRoomListControllerDelegate>

@property (nonatomic,strong) UITableView *categoriesTableView;
@property (nonatomic,strong) MZRoomListController *roomListController;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectRow; // 选中的行

@end

@implementation MZEnterGameRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self initView];
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

    self.selectRow = 0;
    [self.view addSubview:self.categoriesTableView];
    [self.categoriesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.25);
    }];
    self.roomListController.dataArray = self.dataArray[0];
    [self addChildViewController:self.roomListController];
    [self.view addSubview:self.roomListController.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZRoomCell *cell = (MZRoomCell *)[tableView dequeueReusableCellWithIdentifier:@"MZRoomCell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.gradeLabel.text = @"类别";
    cell.intervalLabel.text = @"1000-2000";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectRow = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(didDataArray:clickedAtIndexPath:)]) {
        [self.delegate didDataArray:self.dataArray[indexPath.row] clickedAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_Width * 0.25, 150)];
    NSArray *titleArray = @[@"Open",@"Waiting",@"Running",@"Full"];
    CGFloat scaleHeight = 25;
    for(int i=0; i<titleArray.count ;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font =[UIFont systemFontOfSize:13];
        btn.tag = i+1;
//        btn.frame = CGRectMake(5, 10 + scaleHeight * i, kSCREEN_Width * 0.25 - 20, scaleHeight);
        [btn setBackgroundImage:[UIImage imageNamed:@"remeberPasswordNor"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"remeberPasswordPress"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(10 + (scaleHeight + 10)* i);
            make.width.offset(25);
            make.height.offset(25);
        }];
        
        UILabel *titleLabel =[[UILabel alloc] init];
        titleLabel.text = titleArray[i];
        titleLabel.textColor =[UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(5);
            make.centerY.equalTo(btn.mas_centerY).offset(0);
            make.width.offset(kSCREEN_Width * 0.25 - 35);
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
        _categoriesTableView.backgroundColor = COLOR_BG;
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
@end
