//
//  MZGCDSocketManager.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/10.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZGCDSocketManager.h"
#import "GCDAsyncSocket.h"
#import "KDJSON.h"
//自己设定
#define HOST @"14.21.42.98"
#define PORT 9920

//设置连接超时
#define TIME_OUT 20

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//每次最多读取多少
#define MAX_BUFFER 1024

#define kMaxReconnection_time 5

@interface MZGCDSocketManager()<GCDAsyncSocketDelegate>{

    GCDAsyncSocket *gcdSocket;
    int _reconnection_time;
    NSTimer *_timer;
    NSLock  *theLock;
    
}
@property (nonatomic,copy)connectBlock ConnectedBlock;
//接收完整的包
@property(nonatomic,strong)NSMutableData* completeData;
//完整包的长度
@property(nonatomic,assign)NSInteger lenght;


@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation MZGCDSocketManager

+ (instancetype)shareInstance{

    static dispatch_once_t onceToken;
    static MZGCDSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}

- (void)initSocket
{
    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)connect:(connectBlock)connectblock{
    
    self.ConnectedBlock = connectblock;
    if (![self SocketOpen:HOST port:PORT] )
    {
        
    }
}

- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
{
    if (![gcdSocket isConnected])
    {
        NSError *error = nil;
        [gcdSocket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
    }else{
        if(firstConnect == false){
            self.ConnectedBlock(YES);
        }
    }
    
    return 0;
}

//断开连接
- (void)disConnect
{
    [gcdSocket disconnect];
}

- (void)sendMessage:(NSString *)message{
    //像服务器发送数据
    message =[NSString stringWithFormat:@"%@<EOF>",message];
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [gcdSocket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:0];
//    [gcdSocket readDataToLength:2 withTimeout:READ_TIME_OUT tag:0];
//    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^(){
//        [gcdSocket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:0];
//    }];
//    [self.queue addOperation:operation1];
}

static bool firstConnect = true;
#pragma mark - GCDAsyncSocketDelegate
//连接成功调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    firstConnect = false;
    self.ConnectedBlock(YES);
    //通过定时器不断发送消息，来检测长连接
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
    [self.heartTimer fire];
    
    //心跳写在这...
}

// 心跳连接
-(void)checkLongConnectByServe{
    
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"HeartBeat<EOF>";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [gcdSocket writeData:data withTimeout:1 tag:0];
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    
//    [self connect:^(BOOL connectBlock) {
//        
//    }];
    //断线重连写在这...
    if(_reconnection_time>=0 && _reconnection_time <= kMaxReconnection_time) {
                        [_timer invalidate];
                        _timer=nil;
                        int time = 2;//这里设置重连时间，自己定夺
        _timer= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        _reconnection_time++;
        NSLog(@"socket did reconnection,after %ds try again",time);
        }else{
            _reconnection_time=0;
        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    }

}

- (void)reconnection{
    [self connect:^(BOOL connectBlock) {
        
    }];
}

//写的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [gcdSocket readDataWithTimeout:READ_TIME_OUT tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.completeData appendData:data];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *array = [msg componentsSeparatedByString:@"<EOF>"];
    for(int i=0; i<array.count; i++){
        if([_delegate respondsToSelector:@selector(requestDataWithDict:)]){
            NSString *dataMessage = [array[i] stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
            [_delegate requestDataWithDict:dataMessage];
        }
    }
    NSLog(@"msg----msg%@",msg);
//    self.lenght = [self unpackingLenght:msg];
//    //这里因为有时候会粘包，所以等长度一致，拼接完整之后再发送数据出去
//        NSLog(@"self.completeData.length-%ld  self.lenght-%ld",self.completeData.length ,self.lenght);
//    if (self.completeData.length >= self.lenght) {
////        NSString *type = [self unpackingDicWith:msg];
//        if([msg hasSuffix:@"<EOF>"]){
//            if([_delegate respondsToSelector:@selector(requestDataWithDict:)]){
//                msg = [msg stringByReplacingOccurrencesOfString:@"<EOF>" withString:@""];
//                [_delegate requestDataWithDict:msg];
//            }
//        }
//        self.completeData = 0;
//        self.lenght = 0;
//    }
//    [gcdSocket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    [gcdSocket readDataWithTimeout:READ_TIME_OUT tag:0];
    
}

- (NSString *)num:(int) num{
    NSString *str = [NSString stringWithFormat:@"%d",num];
    int sum = 0 ;
    while(num!=0){
        num /= 10;
        sum++;
    }
    for (int i = sum ; i < 8 ; i ++) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}

//拆分出长度
-(NSInteger)unpackingLenght:(NSString *) packing{
    if (!packing ) return 0;
    NSRange range =  NSMakeRange (0, 37);
    NSString *heard = [packing substringWithRange:range];
    
    NSRange sRange = NSMakeRange(4, 8);
    NSString *lenght = [heard substringWithRange:sRange];
    
    NSInteger slenght = [lenght integerValue];
    return slenght;
}

//拆分出类型
- (NSString *)unpackingHeard:(NSString *)packing{
    if (!packing ) return nil;
    NSRange range =  NSMakeRange (0, 37);
    NSString *heard = [packing substringWithRange:range];
    
    NSRange sRange = NSMakeRange(12, 8);
    NSString *type = [heard substringWithRange:sRange];
    
    return type;
}

//NSDictionary拆包
- (NSDictionary *)unpackingDicWith:(NSString *) packing{
    
    if (!packing ) return nil;
    
    NSRange rjson = NSMakeRange(37, packing.length - 37);
    NSString *json = [packing substringWithRange:rjson];
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    return dic;
}

- (NSMutableData *)completeData{
    if (!_completeData ) {
        _completeData = [[NSMutableData alloc]init];
    }
    return _completeData;
}

- (NSInteger)lenght{
    if (!_lenght) {
        _lenght = 0 ;
    }
    return _lenght;
}

- (NSOperationQueue *)queue{

    if(!_queue){
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}


@end
