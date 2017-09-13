//
//  MZLoginModel.h
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/11.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLoginModel : NSObject

@property (nonatomic, copy) NSString *acc_id;
@property (nonatomic, copy) NSString *acc_name;
@property (nonatomic, copy) NSString *acc_nickname;
@property (nonatomic, copy) NSString *acc_type;
@property (nonatomic, copy) NSString *acc_bal;
@property (nonatomic, copy) NSString *nextchgpwdtime; //当 nextchgpwdtime > NOW, 需要跳去更改密码



@end
