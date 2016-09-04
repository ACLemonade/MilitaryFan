//
//  LoginViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/29.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LeftMenuViewController.h"
#import "AppDelegate.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController
#pragma mark - 协议方法 UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
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
- (IBAction)userLogin:(id)sender {
    BmobQuery *loginQuery = [BmobQuery queryWithClassName:@"UserInfo"];
    loginQuery.limit = 1;
    [loginQuery whereKey:@"userName" equalTo:_accountTF.text];
    [loginQuery whereKey:@"password" equalTo:_passwordTF.text];
    [loginQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"错误信息: %@",error);
        }else{
            if (array.firstObject) {
                //将登录信息写入User.plist文件中
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:kUserPlistPath];
                [dic setObject:_accountTF.text forKey:@"userName"];
                [dic setObject:_passwordTF.text forKey:@"password"];
                [dic setObject:@(YES) forKey:@"loginState"];
                [dic writeToFile:kUserPlistPath atomically:YES];
                //登录成功,弹出提示框
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击确定刷新界面
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertVC addAction:yesAction];
                [self presentViewController:alertVC animated:YES completion:nil];
//                NSLog(@"登录成功");
            }else{
                //登录失败,弹出提示框
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:yesAction];
                [self presentViewController:alertVC animated:YES completion:nil];
//                NSLog(@"登录失败");
            }
        }
    }];
}
//点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
//跳转时触发
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
    [Factory nonNaviClickBackWithViewController:self];
}

@end
