//
//  MZRoomCell.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZGameRoomLeftModel.h"
@interface MZRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bacImageView;

@property (nonatomic, strong) MZGameRoomLeftModel *model;

@end
