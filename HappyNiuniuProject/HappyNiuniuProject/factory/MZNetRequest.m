//
//  MZNetRequest.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZNetRequest.h"

@implementation MZNetRequest


static MZNetRequest *netWork = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[MZNetRequest alloc] init];
    });
    return netWork;
    
}

- (void)connect:(NSString *)ip port:(unsigned int)port timeOut:(int)timeOut block:(ConnectBlock)block
{
    _block = block;
    self.socketHost = ip;
    self.socketPort = port;
    NSError *err = nil;
    if(![self.socket connectToHost:ip onPort:port withTimeout:10 error:&err])
    {
        block(NO);
    }
}

#pragma mark -  连接成功回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    if(_block)
    {
        _block(YES);
    }
    NSLog(@"socket连接成功");
    //每隔20秒像服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"client willDisconnectWithError:%@",err);
    if(_block)
    {
        _block(NO);
    }
    [self.socket disconnect];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"client didWriteDataWithTag:%ld",tag);
    [sock readDataWithTimeout:-1 tag:0];
}

//切断连接
- (void)cutOffSocket{
    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    [self.connectTimer invalidate];
    [self.socket disconnect];
}
#pragma mark -重连
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if(sock.userData == SocketOfflineByServer){
        //服务器掉线，重连
        [self connect:self.socketHost port:self.socketPort timeOut:10 block:_block];
    }else if (sock.userData == SocketOfflineByUser){
        //如果由用户断开，不进行重连
        return;
    }
}


-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(msg){
        if (_successBlock) {
            _successBlock(msg);
        }
    }
}
// 心跳连接
-(void)longConnectToSocket{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
//    NSString *longConnect = @"longConnect";
//    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket readDataWithTimeout:-1 tag:0];
    
    
}

- (void)writeData:(NSData *)data
{
    [self.socket writeData:data withTimeout:30 tag:0];
}

- (AsyncSocket *)socket{

    if(!_socket){
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    return _socket;
}
@end
