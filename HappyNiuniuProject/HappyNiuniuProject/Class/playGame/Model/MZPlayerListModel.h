//
//  MZPlayerListModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/14.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MZPlayerListModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *acc_id;               //用户id
@property (nonatomic, copy) NSString *acc_name;             //用户名
@property (nonatomic, copy) NSString *isbanker;             //是否是庄家
@property (nonatomic, copy) NSString *isview;               //是否是旁观者
@property (nonatomic, copy) NSString *isplay;               //是否是玩家
@property (nonatomic, copy) NSString *game_amount;          //带入金额
@property (nonatomic, copy) NSString *bet_amount;           //投注金额
@property (nonatomic, copy) NSString *game_minbet;          //最小投注金额
@property (nonatomic, copy) NSString *game_maxbet;          //最大投注金额
@property (nonatomic, copy) NSString *banker_amount;        //庄金额
@property (nonatomic, copy) NSArray *card_list;             //牌面
@property (nonatomic, copy) NSString *shape;                //牌结果 ，0：没有牛 | 牛 1~9：1~9 | 10：牛牛 | 11：4 花牛 | 12：5 花牛 | 13：炸弹 | 14：五小牛
@property (nonatomic, copy) NSString *game_result;          //游戏结果 W = WIN, L = Lose
@property (nonatomic, copy) NSString *wl_amount;            //输赢结果


@end
