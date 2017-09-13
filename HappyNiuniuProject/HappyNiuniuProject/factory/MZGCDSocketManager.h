//
//  MZGCDSocketManager.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/10.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^connectBlock)(BOOL connectBlock);
@protocol MZGCDSocketManagerDelegate <NSObject>

//回调需要添加一个类型(鉴定是哪个请求返回的)
- (void)requestDataWithDict:(id)dict;

@end
@interface MZGCDSocketManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
@property (nonatomic, assign)id<MZGCDSocketManagerDelegate> delegate;
@property (nonatomic, assign) int  sendTag;

- (void)connect:(connectBlock)connectblock;
- (void)disConnect;
- (void)sendMessage:(NSString *)message;

@end
