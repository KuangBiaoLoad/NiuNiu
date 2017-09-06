//
//  MZRegisterController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRegisterController.h"
#import "MZTextField.h"

@interface MZRegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MZTextField *emailTxtField;
@property (weak, nonatomic) IBOutlet MZTextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet MZTextField *confirmPwdTxtField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmPwdLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *registerSuggestionLabel;

@end

@implementation MZRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView{

    self.emailLabel.text = RDLocalizedString(@"email");
    self.passwordLabel.text = RDLocalizedString(@"Password");
    self.confirmPwdLabel.text = RDLocalizedString(@"confirmPassword");
    self.emailTxtField.placeholder = RDLocalizedString(@"UserNamePlaceholder");
    self.pwdTxtField.placeholder = RDLocalizedString(@"PasswordPlaceholder");
    self.confirmPwdTxtField.placeholder = RDLocalizedString(@"confirmPwdPlaceholder");
    [self.signUpButton setTitle:RDLocalizedString(@"signUp") forState:UIControlStateNormal];
    self.registerSuggestionLabel.text = RDLocalizedString(@"registerSuggestion");
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
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)signUpClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注册请求
- (void)requestWithRegister{

   
}

@end
