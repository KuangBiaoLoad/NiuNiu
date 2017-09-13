//
//  KDJSON.m
//  KDTools
//
//  Created by 斌 on 15/11/22.
//  Copyright © 2015年 斌. All rights reserved.
//

#import "KDJSON.h"

@implementation KDJSON


+ (id)objectParseJSONString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        return [self changeType:jsonObject];
    }else{
        printf("\nKDJSON : resolve JSON err:%s",[[error.userInfo objectForKey:@"NSLocalizedDescription"] UTF8String]);
        return nil;
    }
    
}

+ (NSString *)JSONStringOfObject:(id)object {
    
    if ([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }else{
            printf("\nKDJSON : resolve JSON err:%s",[[error.userInfo objectForKey:@"NSLocalizedDescription"] UTF8String]);
            return nil;
        }
    }else{
        printf("\nKDJSON : 传入对象无法转换成JSON数据");
        return nil;
    }
    
}


#pragma mark - 私有方法
+ (NSDictionary *)nullDic:(NSDictionary *)myDic{
    
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < keyArr.count; i ++){
        
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    
    return resDic;
}

+ (NSArray *)nullArr:(NSArray *)myArr{
    
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < myArr.count; i ++){
        
        id obj = myArr[i];
        obj = [self changeType:obj];

        [resArr addObject:obj];
    }
    
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string{
    return string;
}


+ (NSString *)nullToString{
    return @"";
}


#pragma mark - 公有方法
+ (id)changeType:(id)myObj{
    
    if ([myObj isKindOfClass:[NSDictionary class]]){
        return [self nullDic:myObj];
    }else if([myObj isKindOfClass:[NSArray class]]){
        return [self nullArr:myObj];
    }else if([myObj isKindOfClass:[NSString class]]){
        return [self stringToString:myObj];
    }else if([myObj isKindOfClass:[NSNull class]]){
        return [self nullToString];
    }else{
        return myObj;
    }
    
}

@end
