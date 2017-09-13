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


@end

@implementation MZRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)loadView{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_Width * 0.19, topHeight, kSCREEN_Width * 0.81, KSCREEN_HEIGHT - topHeight)];
    
}

- (void)initView{
    self.view.backgroundColor = [UIColor clearColor];
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
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MZRoomListCell *cell = (MZRoomListCell *)[tableView dequeueReusableCellWithIdentifier:@"MZRoomListCell"];
    cell.model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if([_delegate respondsToSelector:@selector(didSelectIndexPath:)]){
        [_delegate didSelectIndexPath:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30.0 /568 * kSCREEN_Width;
}

#pragma mark - MZEnterGameRoomControllerDelagate
- (void)didDataArray:(NSArray *)dataArray clickIndexPathRow:(NSInteger)indexpathRow andStatusDict:(NSDictionary *)statusDict{
    
    [self.dataSource removeAllObjects];
//    self.dataSource = dataArray.mutableCopy;//    OPEN = 没有玩家， Waiting = 只有一个玩家， RUNNING = 游戏进行但没做满，  FULL = 坐满
    
    if([[statusDict objectForKey:@"status1"] isEqualToString:@"false"] && [[statusDict objectForKey:@"status2"] isEqualToString:@"false"] && [[statusDict objectForKey:@"status3"] isEqualToString:@"false"] && [[statusDict objectForKey:@"status4"] isEqualToString:@"false"]){
        self.dataSource = dataArray.mutableCopy;
    }
    for(MZRoomListModel *model in dataArray.reverseObjectEnumerator){
    
        if([[statusDict objectForKey:@"status1"] isEqualToString:@"true"]){
            if([model.game_totalplayer isEqualToString:@"0"]){
                [self.dataSource addObject:model];
            }
        }
        if([[statusDict objectForKey:@"status2"] isEqualToString:@"true"]){
            if([model.game_totalplayer isEqualToString:@"1"]){
                [self.dataSource addObject:model];
            }
        }
        if([[statusDict objectForKey:@"status3"] isEqualToString:@"true"]){
            if([model.game_totalplayer intValue] >1 && [model.game_totalplayer intValue] < 6){
                [self.dataSource addObject:model];
            }
        }
        if([[statusDict objectForKey:@"status4"] isEqualToString:@"true"]){
            if([model.game_totalplayer isEqualToString:@"6"]){
                [self.dataSource addObject:model];
            }
        }
    }
    [self.roomListTableView reloadData];
}


#pragma mark - 懒加载
- (UITableView *)roomListTableView{
    
    if(!_roomListTableView){
        _roomListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _roomListTableView.delegate = self;
        _roomListTableView.dataSource = self;
        _roomListTableView.backgroundColor = [UIColor clearColor];
        [_roomListTableView registerNib:[UINib nibWithNibName:@"MZRoomListCell" bundle:nil] forCellReuseIdentifier:@"MZRoomListCell"];
        _roomListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //            _roomListTableView.backgroundColor = [UIColor purpleColor];
        _roomListTableView.showsVerticalScrollIndicator = NO;
    }
    return _roomListTableView;
}


- (NSMutableArray *)dataSource{

    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return  _dataSource;
}

@end
