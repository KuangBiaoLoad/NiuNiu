//
//  MZRoomListController.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBaseController.h"
#import "MZEnterGameRoomController.h"
@protocol MZRoomListControllerDelegate <NSObject>

- (void)didSelectIndexPath:(NSInteger)row;

@end

@interface MZRoomListController : MZBaseController<MZEnterGameRoomControllerDelagate>

@property (nonatomic, weak) id<MZRoomListControllerDelegate>delegate;
@property (nonatomic, strong) NSArray  *dataArray;
@end
