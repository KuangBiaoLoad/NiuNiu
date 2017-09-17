//
//  MZForgetPasswordController.m
//  HappyNiuniuProject
//
//  Created by kuangbiao on 2017/8/25.
//  Copyright © 2017年 kuangbiao. All rights reserved.
//

#import "MZForgetPasswordController.h"
#import "MZGCDSocketManager.h"
#import "MZTextField.h"
#import "KDJSON.h"
@interface MZForgetPasswordController ()<MZGCDSocketManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldpwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *newpwdLabel;
@property (weak, nonatomic) IBOutlet MZTextField *emailTxtField;
@property (weak, nonatomic) IBOutlet MZTextField *oldpwdTxtfield;
@property (weak, nonatomic) IBOutlet MZTextField *newpwdTxtfield;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UILabel *forgetSuggestLabel;

@end

@implementation MZForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBtn];
    [self initView];
}

- (void)initView{

    self.emailLabel.text = RDLocalizedString(@"email");
    self.oldpwdLabel.text = RDLocalizedString(@"oldpwd");
    self.newpwdLabel.text = RDLocalizedString(@"newpwd");
    self.emailTxtField.placeholder = RDLocalizedString(@"UserNamePlaceholder");
    self.oldpwdTxtfield.placeholder = RDLocalizedString(@"oldpwdPlaceholder");
    self.newpwdTxtfield.placeholder = RDLocalizedString(@"newpwdPalceholder");
    [self.changeButton setTitle:RDLocalizedString(@"change") forState:UIControlStateNormal];
    self.forgetSuggestLabel.text = RDLocalizedString(@"registerSuggestion");
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

- (IBAction)changeButtonClickAction:(id)sender {
    if([self.emailTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
        
        [self showFailureView:RDLocalizedString(@"UserNamePlaceholder")];
        return;
    }
    if([self.oldpwdTxtfield.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
    
        [self showFailureView:RDLocalizedString(@"oldpwdPlaceholder")];
        return;
    }
    if([self.newpwdTxtfield.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
        
        [self showFailureView:RDLocalizedString(@"newpwdPalceholder")];
        return;
    }
    [self requestWithForgetPassword];
}


#pragma mark - 忘记密码请求
- (void)requestWithForgetPassword{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3",@"command",[NSString stringWithFormat:@"%@%03d",[Common getCurrentTimes],arc4random()%1000],@"messageId",@{@"acc_name":[self.emailTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"oldpwd":[self.oldpwdTxtfield.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"newpwd":[self.newpwdTxtfield.text stringByReplacingOccurrencesOfString:@" " withString:@""]},@"data", nil];
    [tempDict addEntriesFromDictionary:MBSIDicHeader];
    
    NSString *sendMessage = [KDJSON JSONStringOfObject:tempDict];
    [[MZGCDSocketManager shareInstance] connect:^(BOOL connectBlock) {
        if(connectBlock == YES){
            [[MZGCDSocketManager shareInstance] sendMessage:sendMessage];
        }
    }];

   
}

- (void)requestDataWithDict:(id)dict{

    NSDictionary *dictData = [KDJSON objectParseJSONString:dict];
    if([[dictData objectForKey:@"status"] isEqualToString:@"1"]){
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
