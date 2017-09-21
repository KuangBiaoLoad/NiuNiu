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
@interface MZSettingController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation MZSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginBtn setImage:[self resizeImageWithIOS6Method:@"UserHeadImage-1"] forState:UIControlStateNormal];
}

- (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

-(UIImage*)resizeImageWithIOS6Method:(NSString*)name{
    UIImage *image = [UIImage imageNamed:name];
    //顶端盖的高度
    CGFloat top = 10;
    CGFloat bottom = 10;//低端盖的高度
    CGFloat left = 10;//左端盖的高度
    CGFloat right = 10;//右端盖的高度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    //指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
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
