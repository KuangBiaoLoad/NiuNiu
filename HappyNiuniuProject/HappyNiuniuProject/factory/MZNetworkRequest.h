//
//  MZNetworkRequest.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^connectedToHostBlock) (NSString *hostIP,NSInteger port);
typedef void(^sendCompletedBlock)(NSInteger tag,NSString *error);
typedef void(^didDisconnectedBlock)();

typedef void(^newConnectedBlock)();
typedef void(^readDataBlock)(NSData *data,NSInteger tag);

typedef NS_ENUM(NSInteger, VVEConnectState) {
    VVEConnectStateDisConnected = 0,
    VVEConnectStateConnected,
    VVEConnectStateConnecting
};
/*
 *  一对一读写socket
 */
@interface MZNetworkRequest : NSObject
@property (nonatomic,readonly)VVEConnectState connectState;
@property (nonatomic,assign)BOOL isScanConnect;//是否在扫描连接
@property (nonatomic,strong)NSString *ip;//remote ip
//@property (nonatomic,strong)NSString *name;//remote device name
//@property (nonatomic,assign)BOOL isWifi;//是否是wifi，否则热点
/// 单例
+ (MZNetworkRequest *)shareInstance;
/// 发送部分
/// 链接到指定ip和port的设备，链接成功调用block
- (void)connectToHost:(NSString *)hostIP port:(NSInteger)port connected:(connectedToHostBlock)block didDisconnected:(didDisconnectedBlock)disBlock;
/// 连接成功后发送数据，发送完毕调用block
- (void)sendData:(NSString *)dataStr tag:(NSInteger)tag finishWritedBlock:(sendCompletedBlock)block;
- (void)disconnected;

/// 读取数据，默认超时6s
- (void)readData:(readDataBlock)block;
/// 读取数据
- (void)readData:(readDataBlock)block timeout:(NSInteger)timeout;
/// 接收部分
- (void)acceptPort:(NSInteger)port newConnect:(newConnectedBlock)nBlock readTag:(NSUInteger)tag didReadData:(readDataBlock)rBlock;
@end

