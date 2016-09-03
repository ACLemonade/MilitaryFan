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
//导航控制器返回
+ (void)naviClickBackWithViewController:(UIViewController *)viewController;
//非导航控制器返回
+ (void)nonNaviClickBackWithViewController:(UIViewController *)viewController;
@end
