//
//  MZLoginController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/24.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZLoginController.h"
#import "MZRegisterController.h"
#import "MZGameLobbyController.h"
#import "MZForgetPasswordController.h"
#import "MZForgetView.h"
#import "MZTextField.h"
@interface MZLoginController ()<MZForgetViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MZTextField *meberTxtField;
@property (weak, nonatomic) IBOutlet MZTextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UILabel *memberLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;

@end

@implementation MZLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{
    
    self.memberLoginLabel.text = RDLocalizedString(@"MemberLogin");
    self.usernameLabel.text = RDLocalizedString(@"UserName");
    self.passwordLabel.text = RDLocalizedString(@"Password");
    [self.loginButton setTitle:RDLocalizedString(@"login") forState:UIControlStateNormal];
    self.meberTxtField.placeholder = RDLocalizedString(@"UserNamePlaceholder");
    self.passwordTxtField.placeholder = RDLocalizedString(@"PasswordPlaceholder");
    [self.signUpButton setTitle:RDLocalizedString(@"NewUserSignUp") forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:RDLocalizedString(@"forgetPwdLbl") forState:UIControlStateNormal];

//    FFF2C9
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)registerButtonClickAction:(id)sender {
    MZRegisterController *registerVC = [[MZRegisterController alloc] initWithNibName:@"MZRegisterController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)loginButtonClickAction:(id)sender {
    
//    if ([KDCheckTxt checkTxt:self.meberTxtField.text andTxtType:KDCheckTxtTypeMobile errorMsg:^(NSString *error) {}] == NO) {
//        return;
//    }
//    if ([KDCheckTxt checkTxt:self.passwordTxtField.text andTxtType:KDCheckTxtTypePassword errorMsg:^(NSString *error) {}] == NO) {
//        return;
//    }
    MZGameLobbyController *lobbyVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
    UINavigationController *lobbyNav = [[UINavigationController alloc] initWithRootViewController:lobbyVC];
    [self presentViewController:lobbyNav animated:YES completion:nil];
//    [self.navigationController pushViewController:lobbyVC animated:YES];
}
- (IBAction)forgetPwdButtonClickAction:(id)sender {
    
    
    MZForgetView *forgetView = [[MZForgetView alloc] initWithFrame:self.view.frame];
    forgetView.delegate = self;
    [self.view addSubview:forgetView];
//    MZForgetPasswordController *forgetVC = [[MZForgetPasswordController alloc] initWithNibName:@"MZForgetPasswordController" bundle:nil];
//    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - 输入框改变的时候UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.meberTxtField == textField){  //判断是否时我们想要限定的那个输入框
        if ([toBeString length] > 11) { //如果输入框内容大于11禁止输入
            return NO;
        }
    }
    if(self.passwordTxtField == textField){
        if([toBeString length] > 20){
            return NO;
        }
    }
    return YES;
}



#pragma mark - MZForgetViewDelegate
- (void)ForgetPasswordRequestSuccessBlock{
    NSLog(@"MZForgetViewDelegate ------");
}

#pragma mark - 登录请求
- (void)requestWithLogin{
    
   
}

@end
