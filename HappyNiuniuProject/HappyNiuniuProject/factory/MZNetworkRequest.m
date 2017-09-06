//
//  MZNetworkRequest.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZNetworkRequest.h"
#import "AsyncSocket.h"


#define HostPort 9900

/// 心跳间隔
const NSInteger bitInterval =20;
/// 断开连接后尝试自动连接上一次连接的ip 3次。
const NSInteger tryTimeMax =3;

@interface MZNetworkRequest()
@property (nonatomic,strong)AsyncSocket *serverSocket;
@property (nonatomic,strong)AsyncSocket *receiveSocket;
@property (nonatomic,strong)AsyncSocket *sendSocket;

@property (nonatomic,copy)connectedToHostBlock connectedBlock;
@property (nonatomic,copy)didDisconnectedBlock disConnectedBlock;

@property (nonatomic,copy)newConnectedBlock newConnectedBlock;
@property (nonatomic,copy)sendCompletedBlock completedSendBlock;
@property (nonatomic,copy)readDataBlock readBlock;

/// tag 读取tag
@property (nonatomic,assign)NSInteger readTag;
/// 心跳count
@property (nonatomic,assign)NSInteger heartbitCount;
/// gcd
@property (nonatomic,strong)dispatch_source_t sourceTimer;
/// 当前剩余尝试连接次数，设置0以下可以不尝试重连
@property (nonatomic,assign)NSInteger tryTimeCurrent;
@end

@implementation MZNetworkRequest
+ (MZNetworkRequest *)shareInstance{
    
    static MZNetworkRequest *tcpSocket =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tcpSocket = [[MZNetworkRequest alloc]init];
    });
    return tcpSocket;
}

- (AsyncSocket *)receiveSocket{
    if (!_receiveSocket){
        _receiveSocket = [[AsyncSocket alloc]initWithDelegate:self];
        [_receiveSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
   return  _receiveSocket;
}

- (AsyncSocket *)sendSocket{
    if (!_sendSocket) {
        _sendSocket = [[AsyncSocket alloc]initWithDelegate:self];
        [_sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return _sendSocket;
}

- (void)keepHeartBit{
    _heartbitCount =bitInterval; //倒计时时间
    if (self.sourceTimer ==nil) {
        dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
        self.sourceTimer = timer;
        dispatch_source_set_timer(timer,dispatch_walltime(NULL,0),2.0*NSEC_PER_SEC,0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(_heartbitCount <=0){ //倒计时结束，关闭
                //dispatch_source_cancel(timer);
                _heartbitCount =bitInterval;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"send heart bit");
                    [self sendData:@"" tag:100 finishWritedBlock:^(NSInteger tag,NSString *error) {
                        NSLog(@"send end");
                        if (error) {
                            NSLog(@"heart bit error:%@",error);
                        }
                    }];
                    
                    [self readData:^(NSData *data, NSInteger tag){
                        NSLog(@"heat bit response.");
                    }];
                });
                
                
            }else{
                _heartbitCount-=2;
                NSLog(@"-");
            }
        });
        dispatch_resume(timer);
    }
}
#pragma mark - public method
- (void)connectToHost:(NSString *)hostIP port:(NSInteger)port connected:(connectedToHostBlock)block didDisconnected:(didDisconnectedBlock)disBlock;{
    if (self.connectState ==VVEConnectStateConnected) {
        self.tryTimeCurrent =0;
        [self.sendSocket disconnect];
    }
    if (self.connectState !=VVEConnectStateConnecting && ![self.sendSocket isConnected]) {
        self.ip = hostIP;
        NSError *error;
        self.connectedBlock = block;
        self.disConnectedBlock = disBlock;
        NSLog(@"try to connect to ip:%@",hostIP);
        [self.sendSocket connectToHost:hostIP onPort:port withTimeout:10 error:&error];
        _connectState =VVEConnectStateConnecting;
    }
}

- (void)sendData:(NSString *)dataStr tag:(NSInteger)tag finishWritedBlock:(sendCompletedBlock)block{
    self.completedSendBlock = block;
    if (self.connectState ==VVEConnectStateConnected) {
        [self keepHeartBit];
        NSString *strSend = [NSString stringWithFormat:@"%@\n",dataStr];
        NSData *data = [strSend dataUsingEncoding:NSUTF8StringEncoding];
        [self.sendSocket writeData:data withTimeout:-1 tag:tag];
    }else{
        if (self.completedSendBlock) {
            self.completedSendBlock(tag,NSLocalizedString(@"Disconnect",nil));
        }
    }
}

- (void)readData:(readDataBlock)block{
    [self.sendSocket readDataWithTimeout:10 tag:self.readTag];
    self.readBlock = block;
}

- (void)readData:(readDataBlock)block timeout:(NSInteger)timeout{
    [self.sendSocket readDataWithTimeout:timeout tag:self.readTag];
    self.readBlock = block;
}

- (void)disconnected{
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
        self.sourceTimer =nil;
    }
    if (self.connectState ==VVEConnectStateConnected) {
        self.tryTimeCurrent =0;
        [self.sendSocket disconnect];
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"disconnect:%@",err);
}

- (void)acceptPort:(NSInteger)port newConnect:(newConnectedBlock)nBlock readTag:(NSUInteger)tag didReadData:(readDataBlock)rBlock{
    NSError *error;
    [self.receiveSocket disconnect];
    [self.receiveSocket acceptOnPort:port error:&error];
    self.newConnectedBlock = nBlock;
    self.readBlock = rBlock;
    self.readTag = tag;
}

#pragma mark - AsyncSocket delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    _connectState =VVEConnectStateConnected;
    NSLog(@"==connected==%@",host);
    [self keepHeartBit];
    if (self.connectedBlock) {
        self.connectedBlock(host,port);
    }
    self.tryTimeCurrent =tryTimeMax;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"==disconnected==");
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
        self.sourceTimer =nil;
    }
    
    _connectState =VVEConnectStateDisConnected;
    if (self.disConnectedBlock) {
        self.disConnectedBlock();
    }
    
    if (self.tryTimeCurrent >0 && !self.isScanConnect) {
        NSError *error;
        [self.sendSocket connectToHost:self.ip onPort:HostPort withTimeout:10 error:&error];
        _connectState =VVEConnectStateConnecting;
        self.tryTimeCurrent--;
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    if (self.completedSendBlock) {
        self.completedSendBlock(tag,nil);
    }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    if (self.receiveSocket != newSocket) {
        self.receiveSocket = newSocket;
        [self.receiveSocket readDataWithTimeout:-1 tag:self.readTag];
        if (self.newConnectedBlock) {
            self.newConnectedBlock();
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //    NSString *st = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"recv:%@+",st);
    [self.receiveSocket readDataWithTimeout:-1 tag:self.readTag];
    if (self.readBlock) {
        self.readBlock(data,tag);
    }
}
@end
