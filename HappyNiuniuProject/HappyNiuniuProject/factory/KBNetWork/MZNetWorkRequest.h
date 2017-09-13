//
//  MZNetWorkRequest.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/10.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    requestTypeLogin,
    requestTypeRegister,
    requestTypeForgetPasword,
} requestType;

typedef void (^TCPBlock)(id response, NSString *error);

@interface MZNetWorkRequest : NSObject
@property (nonatomic, assign) requestType type;

+ (MZNetWorkRequest *)sharedInstance;
// 登录请求
- (void)requestLoginWithSendMessage:(NSString *)sendMessage completion:(TCPBlock)block;

@end
