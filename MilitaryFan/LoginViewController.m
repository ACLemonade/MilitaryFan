//
//  LoginViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/29.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController
#pragma mark - 协议方法 UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _accountTF) {
        [_accountTF endEditing:YES];
        [_passwordTF becomeFirstResponder];
    }
    if (textField == _passwordTF) {
        [_passwordTF endEditing:YES];
    }
    return YES;
}
#pragma mark - 方法 Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RegisterViewController *registerVC = segue.destinationViewController;
    WK(weakSelf);
    registerVC.myBlock = ^(NSString *account, NSString *password){
        weakSelf.accountTF.text = account;
        weakSelf.passwordTF.text = password;
    };
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_accountTF becomeFirstResponder];


}

@end
