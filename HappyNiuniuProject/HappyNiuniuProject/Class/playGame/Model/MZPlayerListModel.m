//
//  MZPlayerListModel.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/14.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZPlayerListModel.h"
#import "MZCardListModel.h"
@implementation MZPlayerListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{

    return @{@"card_list":[MZCardListModel class]};
}

@end

