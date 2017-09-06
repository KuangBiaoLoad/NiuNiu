//
//  KDCheckTxt.h
//  KDTools
//
//  Created by 斌 on 15/11/22.
//  Copyright © 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    KDCheckTxtTypeMobile = 0,
    KDCheckTxtTypePassword,
    KDCheckTxtTypeCheckPassword,
    KDCheckTxtTypeSMSCode,
    KDCheckTxtTypeName,
    KDCheckTxtTypeIDCard,
    KDCheckTxtTypeAmout,
    KDCheckTxtTypeCardNo,
    KDCheckTxtTypeCVV2,
    KDCheckTxtTypeExpDate,
    KDCheckTxtTypeMerchantName,
    KDCheckTxtTypePayPassword,
    KDCheckTxtTypeCheckPayPassword,
    KDCheckTxtTypeOldPayPassword,
    
}KDCheckTxtType;

@interface KDCheckTxt : NSObject

//如需要返回错误信息，需要写block
+ (BOOL)checkTxt:(NSString *)string andTxtType:(KDCheckTxtType)type errorMsg:(void (^)(NSString *error))errorBlock;

@end
