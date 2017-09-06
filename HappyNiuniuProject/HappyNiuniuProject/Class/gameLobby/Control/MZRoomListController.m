//
//  MZRoomListController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRoomListController.h"
#import "MZRoomListCell.h"

@interface MZRoomListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *roomListTableView;


@end

@implementation MZRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)loadView{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_Width * 0.25, 0, kSCREEN_Width * 0.75, KSCREEN_HEIGHT)];
    
}

- (void)initView{
    [self.view addSubview:self.roomListTableView];
    [self.roomListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZRoomListCell *cell = (MZRoomListCell *)[tableView dequeueReusableCellWithIdentifier:@"MZRoomListCell"];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([_delegate respondsToSelector:@selector(didSelectIndexPath:)]){
        [_delegate didSelectIndexPath:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

#pragma mark - MZEnterGameRoomControllerDelagate
- (void)didDataArray:(NSArray *)dataArray clickedAtIndexPath:(NSIndexPath *)indexPath{
    
    self.dataArray = dataArray;
    [self.roomListTableView reloadData];
}


#pragma mark - 懒加载
- (UITableView *)roomListTableView{
    
    if(!_roomListTableView){
        _roomListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _roomListTableView.delegate = self;
        _roomListTableView.dataSource = self;
        [_roomListTableView registerNib:[UINib nibWithNibName:@"MZRoomListCell" bundle:nil] forCellReuseIdentifier:@"MZRoomListCell"];
        _roomListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //            _roomListTableView.backgroundColor = [UIColor purpleColor];
        _roomListTableView.showsVerticalScrollIndicator = NO;
    }
    return _roomListTableView;
}

@end
