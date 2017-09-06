//
//  MZPlayerModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/27.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPlayerModel : NSObject

@property (nonatomic, copy)     NSString *userName;             //用户名
@property (nonatomic, copy)     NSString *userHeaderImage;      //用户头像
@property (nonatomic, copy)     NSString *balance;              //余额
@property (nonatomic, copy)     NSString *integral;             //积分
@property (nonatomic, copy)     NSString *goldCoin;             //金币
@property (nonatomic, assign)   bool     banker;                //是否庄家
@property (nonatomic, assign)   bool     beTheBankerNumber;     //坐庄次数
@property (nonatomic, assign)   bool     mainUser;              //主用户(即自己)

@end
