//
//  MZPlayerModel.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/27.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZPlayerModel.h"
#import "MZPlayerListModel.h"
@implementation MZPlayerModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{

    return @{@"playerList":[MZPlayerListModel class]};
}

@end
