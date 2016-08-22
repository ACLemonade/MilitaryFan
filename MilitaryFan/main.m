//
//  main.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define kApplicationID @"cca8546e86bfa3b911a941cac01051b7"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        [Bmob registerWithAppKey:kApplicationID];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
