//
//  LGSocketServe.h
//  AsyncSocketDemo
//
//  Created by ligang on 15/4/3.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"


enum{
    SocketOfflineByServer1,      //服务器掉线
    SocketOfflineByUser1,        //用户断开
    SocketOfflineByWifiCut1,     //wifi 断开
};

@protocol LGSocketServeDelegate <NSObject>

- (void)requestDataReturn:(id)dict;

@end

@interface LGSocketServe : NSObject<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket         *socket;       // socket
@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
@property (nonatomic, assign)id<LGSocketServeDelegate> delegate;
+ (LGSocketServe *)sharedSocketServe;

//  socket连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;



@end
