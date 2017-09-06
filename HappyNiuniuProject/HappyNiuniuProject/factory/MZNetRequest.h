//
//  MZNetRequest.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};
typedef void(^ConnectBlock)(BOOL success);

@interface MZNetRequest : NSObject<AsyncSocketDelegate>

@property (nonatomic, copy) void(^successBlock)(NSString *success);
@property (nonatomic, strong) AsyncSocket   *socket;        //socket
@property (nonatomic, copy)   NSString      *socketHost;    //socket的Host
@property (nonatomic, strong) NSDictionary  *paramsData;    //请求数据
@property (nonatomic, assign) UInt16        socketPort;     //socket的port
@property (nonatomic, retain) NSTimer       *connectTimer;  // 计时器
@property (nonatomic,copy) ConnectBlock block;

+ (instancetype)sharedInstance;     //单例
/**
 *  判断当前所用的IP地址和端口是否可链接
 *
 *  @param ip      服务器IP地址
 *  @param port    端口号
 *  @param timeOut 超时时间
 *  @param block   用来返回是否可链接(YES/NO)
 */
- (void)connect:(NSString *)ip port:(unsigned int)port timeOut:(int)timeOut block:(ConnectBlock)block;
-(void)cutOffSocket;                // 断开socket连接
/**
 *  用来上传数据
 *
 *  @param data 要上传的数据
 */
- (void)writeData:(NSData *)data;


@end
