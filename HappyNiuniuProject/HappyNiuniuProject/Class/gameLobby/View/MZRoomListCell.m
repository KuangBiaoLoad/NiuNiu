//
//  MZRoomListCell.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRoomListCell.h"

@implementation MZRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MZRoomListModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.status,model.limit];
    
}

@end
