//
//  MZMessageCell.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/12.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZMessageCell.h"

@implementation MZMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MZMessageModel *)model{
    _model = model;
//    self.titleLabel.text = model.msg_createdtime;
    if([[MZlocalizableContoller userLanguage] isEqualToString:RDCHINESE]){
       self.contentLabel.text = model.msg_desccn;
    }else{
       self.contentLabel.text = model.msg_descen;
    }
}

@end
