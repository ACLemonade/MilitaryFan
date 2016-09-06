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
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
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
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn bk_addEventHandler:^(id sender) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBarBtn;
}
//+ (void)naviBarButtonWithViewController:(UIViewController *)viewController position:(NSString *)position image:(UIImage *)image text:(NSString *)text{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //设置文字
//    [btn setTitle:text forState:UIControlStateNormal];
//    //设置图片
//    [btn setImage:image forState:UIControlStateNormal];
//    [btn bk_addEventHandler:^(id sender) {
//        [viewController dismissViewControllerAnimated:YES completion:nil];
//    } forControlEvents:UIControlEventTouchUpInside];
//    
//}

@end
