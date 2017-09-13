//
//  MZRegisterController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZRegisterController.h"
#import "MZTextField.h"
#import "KDJSON.h"
#import "MZGCDSocketManager.h"
@interface MZRegisterController ()<UITextFieldDelegate,MZGCDSocketManagerDelegate>
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
    [self createBackBtn];
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
    [MZGCDSocketManager shareInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)createBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat kbackWidth = 51.5/568.0 *kSCREEN_Width;
    backBtn.frame = CGRectMake(9, 4, kbackWidth, 31.5/51.5 *kbackWidth);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"check_backLoggy"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backBtnClickAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpClickAction:(id)sender {
    [self requestWithRegister];
}

#pragma mark - 注册请求
- (void)requestWithRegister{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[self.emailTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"pwd":[self.pwdTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""]},@"data", nil];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"%@",dictData);
}
@end
