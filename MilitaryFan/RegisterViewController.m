//
//  RegisterViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/29.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *validationTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;

@property (weak, nonatomic) IBOutlet UIButton *validationBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UILabel *accountWarningLb;
@property (weak, nonatomic) IBOutlet UILabel *validationWarningLb;
@property (weak, nonatomic) IBOutlet UILabel *passwordWarningLb;
@property (weak, nonatomic) IBOutlet UILabel *confirmWarningLb;

@end


@implementation RegisterViewController
#pragma mark - 协议方法 UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _accountTF) {
        if ([_accountTF.text isEqualToString:@""]) {
            _accountWarningLb.text = @"昵称不能为空";
        }else{
            _accountWarningLb.text = @"";
        }
    }
    if (textField == _validationTF) {
        if ([_validationTF.text isEqualToString:@""]&&[_validationTF resignFirstResponder]) {
            _validationWarningLb.text = @"验证码不能为空";
        }else{
            _validationWarningLb.text = @"";
        }
    }
    if (textField == _passwordTF) {
        if ([_passwordTF.text isEqualToString:@""]) {
            _passwordWarningLb.text = @"密码不能为空";
        }else{
            _passwordWarningLb.text = @"";
        }
    }
    if (textField == _confirmTF) {
        if ([_confirmTF.text isEqualToString:_passwordTF.text]) {
            _confirmWarningLb.text = @"";
        }else{
            _confirmWarningLb.text = @"两次输入不一致";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _accountTF) {
        [_accountTF endEditing:YES];
        [_phoneTF becomeFirstResponder];
    }
    if (textField == _phoneTF) {
        [_phoneTF endEditing:YES];
    }
    if (textField == _validationTF) {
        [_validationTF endEditing:YES];
        [_passwordTF becomeFirstResponder];
    }
    if (textField == _passwordTF) {
        [_passwordTF endEditing:YES];
        [_confirmTF becomeFirstResponder];
    }
    if (textField == _confirmTF) {
        [_confirmTF endEditing:YES];
    }
    return YES;
}
#pragma mark - 方法 Methods
//获取验证码
- (IBAction)getValidation:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
    }];
    
}
//注册
- (IBAction)userRegister:(id)sender {
    //判断验证码是否正确
    [SMSSDK commitVerificationCode:_validationTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
    }];
}


- (void)textFieldChangeText:(UITextField *)textField{
    if (textField == _phoneTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        if (textField.text.length == 11) {
            _validationBtn.enabled = YES;
            _validationBtn.backgroundColor = kRGBA(21, 162, 251, 1.0);
        }else{
            _validationBtn.enabled = NO;
            _validationBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_accountTF becomeFirstResponder];
    //添加textfield的text值变化的事件
    [_phoneTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    
}

@end
