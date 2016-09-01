//
//  ModifyPasswordViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/1.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@property (weak, nonatomic) IBOutlet UILabel *oldWarningLb;
@property (weak, nonatomic) IBOutlet UILabel *newwarningLb;
@property (weak, nonatomic) IBOutlet UILabel *confirmWarningLb;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (nonatomic) BOOL haveOldPwd;
@property (nonatomic) BOOL haveNewPwd;
@property (nonatomic) BOOL haveConfirm;
@end

@implementation ModifyPasswordViewController
#pragma mark - 协议方法 UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _oldPasswordTF) {
        if ([_oldPasswordTF.text isEqualToString:@""]) {
            _oldWarningLb.text = @"密码不能为空";
            _haveOldPwd = NO;
        }else{
            _oldWarningLb.text = @"";
            _haveOldPwd = YES;
        }
        BmobQuery *pwdQuery = [BmobQuery queryWithClassName:@"UserInfo"];
        [pwdQuery whereKey:@"password" equalTo:_oldPasswordTF.text];
        pwdQuery.limit = 1;
        [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (!error) {
                if (array.firstObject) {
                    _oldWarningLb.text = @"";
                    _haveOldPwd = YES;
                }else{
                    _oldWarningLb.text = @"密码不正确";
                    _haveOldPwd = NO;
                }
            }
        }];
    }
    if (textField == _newpasswordTF) {
        if ([_newpasswordTF.text isEqualToString:@""]) {
            _newwarningLb.text = @"密码不能为空";
            _haveNewPwd = NO;
        }else{
            _newwarningLb.text = @"";
            _haveNewPwd = YES;
        }
    }
    if (textField == _confirmPasswordTF) {
        if ([_confirmPasswordTF.text isEqualToString:_newpasswordTF.text]) {
            _confirmWarningLb.text = @"";
            _haveConfirm = YES;
        }else{
            _confirmWarningLb.text = @"两次输入不一致";
            _haveConfirm = NO;
        }
    }
    if (_haveOldPwd && _haveNewPwd && _haveConfirm) {
        _modifyBtn.enabled = YES;
        _modifyBtn.backgroundColor = kRGBA(21, 126, 251, 1.0);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _oldPasswordTF) {
        [_oldPasswordTF endEditing:YES];
        [_newpasswordTF becomeFirstResponder];
    }
    if (textField == _newpasswordTF) {
        [_newpasswordTF endEditing:YES];
        [_confirmPasswordTF becomeFirstResponder];
    }
    if (textField == _confirmPasswordTF) {
        [_confirmPasswordTF endEditing:YES];
    }
    return YES;
}
#pragma mark - 方法 Methods
- (IBAction)clickModify:(id)sender {
    BmobObject *obj = [BmobObject objectWithClassName:@"UserInfo"];
    [obj setObject:_newpasswordTF.text forKey:@"password"];
    [self notice];
}
- (void)notice{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:yesAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_oldPasswordTF becomeFirstResponder];
    _haveOldPwd = NO;
    _haveNewPwd = NO;
    _haveConfirm = NO;
    [Factory naviClickBackWithViewController:self];
}

@end
