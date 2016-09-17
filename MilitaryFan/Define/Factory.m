//
//  Factory.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "Factory.h"
#import <UIControl+BlocksKit.h>

@implementation Factory
+ (void)naviClickBackWithViewController:(UIViewController *)viewController{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"menu_backBlack"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn bk_addEventHandler:^(id sender) {
        [viewController.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBarBtn;
}
+ (void)nonNaviClickBackWithViewController:(UIViewController *)viewController{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"menu_backBlack"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn bk_addEventHandler:^(id sender) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBarBtn;
}
- (BOOL)isUserLogin{
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSNumber *loginState = [userDic objectForKey:@"loginState"];
    if (loginState.integerValue) {
        return YES;
    }else{
        return NO;
    }
}
+ (void)textHUDWithVC:(UIViewController *)vc text:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(text, @"HUD message title");
    [hud hideAnimated:YES afterDelay:2.f];
}
+ (void)autoShowHUDWithVC:(UIViewController *)vc withDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.navigationController.view animated:YES];
    [hud hideAnimated:YES afterDelay:delay];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
}
@end
