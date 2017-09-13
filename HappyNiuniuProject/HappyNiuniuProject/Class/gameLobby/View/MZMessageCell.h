//
//  MZMessageCell.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/12.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMessageModel.h"
@interface MZMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) MZMessageModel *model;

@end
