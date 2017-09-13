//
//  MZNetWorkRequest.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/10.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZNetWorkRequest.h"
#import "LGSocketServe.h"
#import "KDJSON.h"

@interface MZNetWorkRequest ()<LGSocketServeDelegate>

@property (nonatomic, strong) LGSocketServe *socketServe;

@end

@implementation MZNetWorkRequest


static MZNetWorkRequest *instance = nil;

+ (MZNetWorkRequest *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MZNetWorkRequest alloc] init];
    });
    return instance;
}

- (void)requestLoginWithSendMessage:(NSString *)sendMessage completion:(TCPBlock)block{

    self.socketServe = [LGSocketServe sharedSocketServe];
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [self.socketServe cutOffSocket];
    self.socketServe.socket.userData = SocketOfflineByServer1;
    [self.socketServe startConnectSocket];
    self.socketServe.delegate = self;
    self.type = requestTypeLogin;
    [self.socketServe sendMessage:sendMessage];
}


#pragma mark - LGSocketServeDelegate
- (void)requestDataReturn:(id)dict{
     NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
    [dictData objectForKey:@"command"];
     [self receive:nil withType:(int)[dictData objectForKey:@"command"]];
    
}

- (void)receive:(TCPBlock)block withType:(int )command{

    switch (self.type) {
        case 1:
            
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)receiveLogincompletion:(TCPBlock)block{

}

@end
