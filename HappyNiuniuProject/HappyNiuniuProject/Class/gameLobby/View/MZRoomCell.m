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
//    self.gradeLabel.textColor = [UIColor grayColor];
//    self.gradeLabel.highlightedTextColor = [UIColor redColor];
//    self.intervalLabel.textColor =[UIColor grayColor];
//    self.intervalLabel.highlightedTextColor = [UIColor redColor];
    if(iPhone5){
        self.gradeLabel.font = [UIFont systemFontOfSize:10];
        self.intervalLabel.font = [UIFont systemFontOfSize:10];
    }else if (iPhone6){
        self.gradeLabel.font = [UIFont systemFontOfSize:12];
        self.intervalLabel.font = [UIFont systemFontOfSize:12];
    }else if (iPhone6Plus){
        self.gradeLabel.font = [UIFont systemFontOfSize:14];
        self.intervalLabel.font = [UIFont systemFontOfSize:14];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.gradeLabel.highlighted = selected;
    self.intervalLabel.highlighted = selected;
}

- (void)setModel:(MZGameRoomLeftModel *)model{

    _model = model;
    
    if([[MZlocalizableContoller userLanguage] isEqualToString:RDCHINESE]){
        self.gradeLabel.text = _model.gamecat_desccn1;
        self.intervalLabel.text = _model.gamecat_desccn2;
    }else{
        self.gradeLabel.text = _model.gamecat_descen1;
        self.intervalLabel.text = _model.gamecat_descen2;
    }
    
    self.intervalLabel.shadowColor = [UIColor colorWithHexString:_model.offsetColorHexStr];
    self.gradeLabel.shadowColor = [UIColor colorWithHexString:_model.offsetColorHexStr];
    self.bacImageView.image = [UIImage imageNamed:_model.imageStr];
}

@end
