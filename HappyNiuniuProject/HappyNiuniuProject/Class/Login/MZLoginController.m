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
#import "MZTextField.h"
#import "KDJSON.h"
#import "MZGCDSocketManager.h"
#import "MZLoginModel.h"

@interface MZLoginController ()<UITextFieldDelegate,MZGCDSocketManagerDelegate>
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
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MZGCDSocketManager shareInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)registerButtonClickAction:(id)sender {
    MZRegisterController *registerVC = [[MZRegisterController alloc] initWithNibName:@"MZRegisterController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)loginButtonClickAction:(id)sender {

    if([self.meberTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
    
        [self showFailureView:RDLocalizedString(@"UserNamePlaceholder")];
        return;
    }
    if([self.passwordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
        
         [self showFailureView:RDLocalizedString(@"PasswordPlaceholder")];
        return;
    }
    
    [self requestWithLogin];
}
- (IBAction)forgetPwdButtonClickAction:(id)sender {
    MZForgetPasswordController *forgetVC = [[MZForgetPasswordController alloc] initWithNibName:@"MZForgetPasswordController" bundle:nil];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
#pragma mark - 登录请求
- (void)requestWithLogin{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[self.meberTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"pwd":[self.passwordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
        [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];
   
}
-(void)requestDataWithDict:(id)dict{

    NSDictionary *dictData =  [KDJSON objectParseJSONString:dict];
    if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
        
        MZLoginModel *model = [MZLoginModel yy_modelWithDictionary:[dictData objectForKey:@"data"]];
        [Common setData:model key:@"loginModel"];

        if([model.nextchgpwdtime isEqualToString:@"NOW"]){
            MZForgetPasswordController *forgetVC = [[MZForgetPasswordController alloc] initWithNibName:@"MZForgetPasswordController" bundle:nil];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }else{
            MZGameLobbyController *lobbyVC = [[MZGameLobbyController alloc] initWithNibName:@"MZGameLobbyController" bundle:nil];
            UINavigationController *lobbyNav = [[UINavigationController alloc] initWithRootViewController:lobbyVC];
            [self presentViewController:lobbyNav animated:YES completion:nil];

        }
    }
    NSLog(@"%@",dictData);
}

@end
