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
@import CoreLocation;

@interface LoginViewController () <UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *meLocation;
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
#pragma mark - 协议方法 CLLocationManagerDelegate
//定位成功以后,返回位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //    NSLog(@"location %@", locations);
    //地理反编码 经纬度-->位置
    CLLocation *myLocation = locations.firstObject;
    CLGeocoder *coder = [CLGeocoder new];
    [coder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        if (!mark) {
            return;
        }else{
            //            NSLog(@"%@", mark.addressDictionary);
            //省
            NSString *administrativeArea = mark.administrativeArea;
            //市
            NSString *locality = mark.locality;
            //区
            NSString *subLocality = mark.subLocality;
            //街道
            NSString *thoroughfare = mark.thoroughfare;
            
            self.meLocation = [NSString stringWithFormat:@"%@%@%@%@", administrativeArea, locality, subLocality, thoroughfare];
        }
    }];
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
                BmobObject *userObj = (BmobObject *)array.firstObject;
                [[NSOperationQueue new] addOperationWithBlock:^{
                    //将登录信息写入User.plist文件中
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:kUserPlistPath];
                    [dic setObject:_accountTF.text forKey:@"userName"];
                    [dic setObject:_passwordTF.text forKey:@"password"];
                    [dic setObject:@(YES) forKey:@"loginState"];
                    [dic writeToFile:kUserPlistPath atomically:YES];
                    //创建每个用户独有的文件夹
                    [[NSFileManager defaultManager] createDirectoryAtPath:kUserDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                    //每个用户独有的plist文件
                    NSMutableDictionary *meDic = [NSMutableDictionary dictionary];
                    [meDic setObject:_accountTF.text forKey:@"userName"];
                    [meDic setObject:[userObj objectForKey:@"headImageURL"] forKey:@"headImageURL"];
                    [meDic setObject:self.meLocation forKey:@"location"];
                    [meDic writeToFile:kMePlistPath atomically:YES];
                    //将位置,头像信息存入云端数据库
                    [userObj setObject:self.meLocation forKey:@"location"];
                    [userObj updateInBackground];
                }];
                //登录成功,弹出提示框
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.view endEditing:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.locationManager startUpdatingLocation];
}
#pragma mark - 懒加载 LazyLoad
- (CLLocationManager *)locationManager {
    if(_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //前台定位
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}
@end
