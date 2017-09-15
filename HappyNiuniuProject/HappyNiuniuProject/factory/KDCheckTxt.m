 //
//  KDCheckTxt.m
//  KDTools
//
//  Created by 斌 on 15/11/22.
//  Copyright © 2015年 斌. All rights reserved.
//

#import "KDCheckTxt.h"
#import "KDAlertView.h"
@implementation KDCheckTxt


+ (BOOL)checkTxt:(NSString *)string andTxtType:(KDCheckTxtType)type errorMsg:(void (^)(NSString *error))errorBlock{
    
    NSString *tmpMsgTxt = @"";
    
    NSString *content = @"";
    
    NSString *regex = @"";
    
    int minLength = 0;
    int maxLength = 0;
    
    switch (type){
        case KDCheckTxtTypeMobile://mobile
            content = @"手机号码";
            regex = @"^[1][3-8]+\\d{9}";
            minLength = 11;
            maxLength = 11;
            break;
        case KDCheckTxtTypePassword://password
            content = @"密码";
//            regex = @"[^\u4e00-\u9fa5]+";
            minLength = 6;
            maxLength = 20;
            break;
        case KDCheckTxtTypeCheckPassword://password
            content = @"验证密码";
            regex = @"[^\u4e00-\u9fa5]+";
            minLength = 6;
            maxLength = 20;
            break;
        case KDCheckTxtTypeSMSCode://sms code
            content = @"短信验证码";
            regex = @"[0-9]+";
            minLength = 6;
            maxLength = 6;
            break;
        case KDCheckTxtTypeName://name
            content = @"姓名";
            regex = @"[\\u4e00-\\u9fa5·•]+";
            minLength = 2;
            maxLength = 10;
            break;
        case KDCheckTxtTypeIDCard://idCard
            content = @"身份证号码";
            regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
            minLength = 18;
            maxLength = 18;
            break;
        case KDCheckTxtTypeAmout://Amount
            content = @"金额";
            regex = @"^\\d+.\\d{2}$";
            minLength = 4;
            maxLength = 9;
            break;
        case KDCheckTxtTypeCardNo://cardNo
            content = @"银行卡";
            regex = @"\\d+";
            minLength = 14;
            maxLength = 25;
            break;
        case KDCheckTxtTypeCVV2://cvv2
            content = @"cvv2";
            regex = @"\\d{3}";
            minLength = 3;
            maxLength = 3;
            break;
        case KDCheckTxtTypeExpDate://expDate
            content = @"有效期";
            regex = @"\\d+";
            minLength = 4;
            maxLength = 4;
            break;
        case KDCheckTxtTypeMerchantName://MerchantName
            content = @"商户名";
            regex = @"[\\u4e00-\\u9fa5A-Za-z0-9]+";
            minLength = 2;
            maxLength = 15;
            break;
        case KDCheckTxtTypePayPassword://pay password
            content = @"支付密码";
            regex = @"[0-9]+";
            minLength = 6;
            maxLength = 6;
            break;
        case KDCheckTxtTypeCheckPayPassword://check pay password
            content = @"验证支付密码";
            regex = @"[0-9]+";
            minLength = 6;
            maxLength = 6;
            break;
        case KDCheckTxtTypeOldPayPassword://old pay password
            content = @"旧支付密码";
            regex = @"[0-9]+";
            minLength = 6;
            maxLength = 6;
            break;
        default:
            break;
    }
    
    
    
    if ([string isEqualToString:@""]){
        tmpMsgTxt = [@"请输入" stringByAppendingString:content];
    }else if (string.length < minLength && string.length != 0 ){
        tmpMsgTxt = [NSString stringWithFormat:@"输入的%@长度不足%d位",content,minLength];
    }else if (string.length > maxLength ){
        tmpMsgTxt = [NSString stringWithFormat:@"输入的%@长度大于%d位",content,maxLength];
    }else{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        if ([predicate evaluateWithObject:string] == NO && ![content isEqualToString: @"密码"]){
            
            tmpMsgTxt = [@"请输入正确的" stringByAppendingString:content];
            
//            if ([content isEqualToString: @"密码"]){
//                tmpMsgTxt = [tmpMsgTxt stringByAppendingString:@":6位或以上的数字或字母、特殊字符"];
//            }
            
            
        }else{
            
            //other
            if ((type == KDCheckTxtTypeAmout) && [string isEqualToString:@"0.00"]) {
                
                tmpMsgTxt = [content stringByAppendingString:@"不能为0元"];
            }
        }
        
    }
    
    if (![tmpMsgTxt isEqualToString:@""]) {
        if (errorBlock){
            [KDAlertView alertWithMessage:tmpMsgTxt];
            errorBlock(tmpMsgTxt);
        }
    }
    
    
    return [tmpMsgTxt isEqualToString:@""];

}

@end
