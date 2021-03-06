//
//  MZEnterGameRoomController.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBaseController.h"
#import "MZGameTypeModel.h"
@protocol MZEnterGameRoomControllerDelagate <NSObject>

@optional
//- (void)didTableView:(UITableView *)tableView clickedAtIndexPath:(NSIndexPath*)indexPath;

- (void)didDataArray:(NSArray *)dataArray clickIndexPathRow:(NSInteger)indexpathRow andStatusDict:(NSDictionary *)statusDict;

@end
@interface MZEnterGameRoomController : MZBaseController<MZEnterGameRoomControllerDelagate>

@property (nonatomic,weak) id<MZEnterGameRoomControllerDelagate>delegate;

@property (nonatomic, strong)MZGameTypeModel *gameTypeModel;

@end
