//
//  MZPlayerModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/27.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPlayerModel : NSObject<YYModel>

@property (nonatomic, copy)    NSString *gametype_id;
@property (nonatomic, copy)    NSString *gamecat_id;
@property (nonatomic, copy)    NSString *game_id;
@property (nonatomic, copy)    NSString *room_status;       //(0:准备中/1:下注倒计时/2：下注倒计时截止,下注未满,进入等待状态/3:开牌倒计时/4:下一盘游戏倒计时)
@property (nonatomic, copy)    NSString *game_minbuyin;     //最小带入金额
@property (nonatomic, copy)    NSString *game_maxbuyin;     //最大带入金额
@property (nonatomic, copy)    NSArray *playerList;
@property (nonatomic, copy)    NSString *game_betsecond;        //玩家下注倒计时
@property (nonatomic, copy)    NSString *game_opencardsecond;   //开牌倒计时
@property (nonatomic, copy)    NSString *game_initiatesecond;


@end
