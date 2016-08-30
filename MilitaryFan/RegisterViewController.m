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

@property (nonatomic) BOOL haveAccount;
@property (nonatomic) BOOL haveValidation;
@property (nonatomic) BOOL havePassword;
@property (nonatomic) BOOL haveConfirm;
@end


@implementation RegisterViewController
#pragma mark - 协议方法 UITextField Delegate
//textfield结束编辑时触发
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _accountTF) {
        if ([_accountTF.text isEqualToString:@""]) {
            _accountWarningLb.text = @"昵称不能为空";
            _haveAccount = NO;
        }else{
            //查询数据库,昵称是否重复
            BmobQuery *accountQuery = [BmobQuery queryWithClassName:@"UserInfo"];
            [accountQuery whereKey:@"userName" equalTo:_accountTF.text];
            accountQuery.limit = 1;
            [accountQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"error: %@", error);
                }else{
                    if (array.firstObject) {
                        _accountWarningLb.text = @"昵称已存在";
                        _haveAccount = NO;
//                        NSLog(@"%@", [array objectAtIndex:0]);
                    }else{
                        _accountWarningLb.text = @"昵称可以使用";
                        _haveAccount = YES;
//                        NSLog(@"没有相匹配的数据");
                    }
                }
            }];
        }
        
    }
    if (textField == _validationTF) {
        if ([_validationTF.text isEqualToString:@""]) {
            _validationWarningLb.text = @"验证码不能为空";
            _haveValidation = NO;
           
        }else{
            _validationWarningLb.text = @"";
            _haveValidation = YES;
        }
    }
    if (textField == _passwordTF) {
        if ([_passwordTF.text isEqualToString:@""]) {
            _passwordWarningLb.text = @"密码不能为空";
            _havePassword = NO;
        }else{
            _passwordWarningLb.text = @"";
            _havePassword = YES;
        }
    }
    if (textField == _confirmTF) {
        if ([_confirmTF.text isEqualToString:_passwordTF.text]) {
            _confirmWarningLb.text = @"";
            _haveConfirm = YES;
        }else{
            _confirmWarningLb.text = @"两次输入不一致";
            _haveConfirm = NO;
        }
    }
    if (_haveAccount && _haveValidation && _havePassword && _haveConfirm) {
        _registerBtn.enabled = YES;
        _registerBtn.backgroundColor = kRGBA(0, 122, 255, 1.0);
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
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"手机号码格式错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [alertVC addAction:yesAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
    
}
//注册
- (IBAction)userRegister:(id)sender {
    //是否可以注册
    
        //判断验证码是否正确
        [SMSSDK commitVerificationCode:_validationTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证成功");
                BmobObject *userInfo = [BmobObject objectWithClassName:@"UserInfo"];
                [userInfo setObject:_accountTF.text forKey:@"userName"];
                [userInfo setObject:_passwordTF.text forKey:@"password"];
                [userInfo setObject:_phoneTF.text forKey:@"phoneNumber"];
                [userInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    //判断保存是否成功
                    if (isSuccessful) {
                        NSLog(@"注册成功!");
                        //添加提示框(注册是否成功)
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            _myBlock(self.accountTF.text, self.passwordTF.text);
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        NSLog(@"错误信息: %@", error);
                    }
                }];
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
    [_accountTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    [_phoneTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    self.haveAccount = NO;
    self.haveValidation = NO;
    self.havePassword = NO;
    self.haveConfirm = NO;
    
}

@end
