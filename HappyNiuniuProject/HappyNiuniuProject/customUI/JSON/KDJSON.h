//
//  KDJSON.h
//  KDTools
//
//  Created by 斌 on 15/11/22.
//  Copyright © 2015年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDJSON : NSObject

/**
 *  JSON串 -> dict/ar
 *
 *  @param str JSON串
 *
 */
+ (id)objectParseJSONString:(NSString *)string;


/**
 *  dict/ar -> JSON串
 *
 *  @param object dict/ar
 *
 */
+ (NSString *)JSONStringOfObject:(id)object;


@end
