//
//  MZRoomListCell.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZRoomListModel.h"

@protocol MZRoomListCellDelegate <NSObject>



@end

@interface MZRoomListCell : UITableViewCell

@property (nonatomic, strong) MZRoomListModel *model;

@end
