//
//  MZRoomListModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZRoomListModel : NSObject

@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *gametype_id;
@property (nonatomic, copy) NSString *gamecat_id;
@property (nonatomic, copy) NSString *game_minbuyin;
@property (nonatomic, copy) NSString *game_maxbuyin;
@property (nonatomic, copy) NSString *game_betsecond;
@property (nonatomic, copy) NSString *game_initiatesecond;
@property (nonatomic, copy) NSString *game_minbet;
@property (nonatomic, copy) NSString *game_maxbetpctg;
@property (nonatomic, copy) NSString *game_bankerbid;
@property (nonatomic, copy) NSString *game_totalplayer;
@property (nonatomic, copy) NSString *game_status;
@end
