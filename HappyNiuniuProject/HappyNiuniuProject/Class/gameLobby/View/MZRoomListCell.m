//
//  MZRoomListCell.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRoomListCell.h"

@interface MZRoomListCell()

@property (weak, nonatomic) IBOutlet UILabel *buyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *betLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyinLimeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *betMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankerMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@end

@implementation MZRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if(iPhone5){
        [self setTitleFontWithSize:10];
    }else if (iPhone6){
        [self setTitleFontWithSize:12];
    }else if (iPhone6Plus){
        [self setTitleFontWithSize:13];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MZRoomListModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.status,model.limit];
    
//    BUYIN 1234/5222 Bet LIMIT 1234     	BANKER 1234  Player《zanting》open
  
    
}


- (void)setTitleFontWithSize:(CGFloat)fontSize{
    self.buyinLabel.font = [UIFont systemFontOfSize:fontSize];
    self.betLabel.font = [UIFont systemFontOfSize:fontSize];
    self.bankerLabel.font = [UIFont systemFontOfSize:fontSize];
    self.playerLabel.font = [UIFont systemFontOfSize:fontSize];
    self.buyinLimeiLabel.font = [UIFont systemFontOfSize:fontSize];
    self.betMoneyLabel.font = [UIFont systemFontOfSize:fontSize];
    self.bankerMoneyLabel.font = [UIFont systemFontOfSize:fontSize];
    self.statusLabel.font = [UIFont systemFontOfSize:fontSize];
    
}
@end
