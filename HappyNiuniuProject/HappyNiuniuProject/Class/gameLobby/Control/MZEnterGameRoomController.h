//
//  MZEnterGameRoomController.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBaseController.h"

@protocol MZEnterGameRoomControllerDelagate <NSObject>

@optional
//- (void)didTableView:(UITableView *)tableView clickedAtIndexPath:(NSIndexPath*)indexPath;

- (void)didDataArray:(NSArray *)dataArray clickedAtIndexPath:(NSIndexPath*)indexPath;

@end
@interface MZEnterGameRoomController : MZBaseController<MZEnterGameRoomControllerDelagate>

@property (nonatomic,weak) id<MZEnterGameRoomControllerDelagate>delegate;

@end
