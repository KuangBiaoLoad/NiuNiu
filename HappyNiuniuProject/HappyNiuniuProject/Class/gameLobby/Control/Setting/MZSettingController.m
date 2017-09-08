//
//  MZSettingController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/9/5.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZSettingController.h"
#import "NSBundle+MZLanguage.h"
#import "MZGameLobbyController.h"
#import "MZBuyChips.h"
@interface MZSettingController ()<MZBuyChipsDelegate>

@end

@implementation MZSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    [NSBundle setLanguage:language];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"myLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    // 我们要把系统windown的rootViewController替换掉
    MZGameLobbyController *gameVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = gameVC;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changeChinaLanguageClick:(id)sender {
    
    // 设置中文
//    [MZlocalizableContoller setUserlanguage:RDCHINESE];
//    MZGameLobbyController *gameVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
//    [UIApplication sharedApplication].keyWindow.rootViewController = gameVC;
////    [self dismissViewControllerAnimated:YES completion:nil];
    
    MZBuyChips *forgetView = [[MZBuyChips alloc] initWithFrame:self.view.frame withMax:100 withMin:0];
    forgetView.delegate = self;
    [self.view addSubview:forgetView];
    
}
- (void)buyChipsWithMoney:(float)money{

    NSLog(@"money-------------%f",money);
}


- (IBAction)changeEnglishLanguageClick:(id)sender {
    // 设置英文
    [MZlocalizableContoller setUserlanguage:RDENGLISH];
    MZGameLobbyController *gameVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
    UINavigationController *gameNav = [[UINavigationController alloc] initWithRootViewController:gameVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = gameNav;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
