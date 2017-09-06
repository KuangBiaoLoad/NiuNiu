//
//  MZRoomCell.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRoomCell.h"

@implementation MZRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.gradeLabel.textColor = [UIColor grayColor];
    self.gradeLabel.highlightedTextColor = [UIColor redColor];
    self.intervalLabel.textColor =[UIColor grayColor];
    self.intervalLabel.highlightedTextColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.gradeLabel.highlighted = selected;
    self.intervalLabel.highlighted = selected;
}

@end
