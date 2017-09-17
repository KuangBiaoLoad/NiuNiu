//
//  MZBaseController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZBaseController.h"
#import "KDJSON.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface MZBaseController ()<MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD * hud;

@end

@implementation MZBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 失败提示框
- (void)showFailureView:(NSString *)message
{
    if (!_hud) {
        AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _hud = [[MBProgressHUD alloc] initWithView:delegat.window];
        [delegat.window addSubview:_hud];
    }
    _hud.cornerRadius = 4;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_no"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelFont = [UIFont systemFontOfSize:14.f];
    if (message) {
        if (message.length >15) {
            _hud.detailsLabelText = message;
        }else{
            _hud.labelText = message;
        }
    }else{
        _hud.labelText = @"请求失败，您的网络不稳定。Code.1004";
    }
    _hud.delegate = self;
    [_hud show:YES];
    [_hud hide:YES afterDelay:1.25f];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
//获取到当前所在的视图
- (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

@end
