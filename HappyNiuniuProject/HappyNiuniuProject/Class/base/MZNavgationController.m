//
//  MZNavgationController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZNavgationController.h"

@interface MZNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation MZNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    [self setupNavigationBar];
}

- (void)setupNavigationBar
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.translucent = NO;
    [appearance setBarTintColor:[UIColor colorWithHexString:@"97d8d1"]];
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttribute[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [appearance setTitleTextAttributes:textAttribute];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed =YES;
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
//        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [backButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:YES];
}
- (void)popView
{
    [self popViewControllerAnimated:YES];
}



@end
