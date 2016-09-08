//
//  Factory.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Factory : NSObject
//导航控制器返回(默认)
+ (void)naviClickBackWithViewController:(UIViewController *)viewController;
//导航控制器返回
//+ (void)naviBarButtonWithViewController:(UIViewController *)viewController position:(NSString *)position image:(UIImage *)image text:(NSString *)text;
//非导航控制器返回
+ (void)nonNaviClickBackWithViewController:(UIViewController *)viewController;

@end
