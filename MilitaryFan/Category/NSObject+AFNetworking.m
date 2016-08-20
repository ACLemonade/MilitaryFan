//
//  NSObject+AFNetworking.m
//  day08_Beauty
//
//  Created by Lemonade on 16/8/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "NSObject+AFNetworking.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@implementation NSObject (AFNetworking)
+ (id)GET:(NSString *)path parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress completionHandle:(void (^)(id, NSError *))completionHandle{
    //判断当前网络状态
//    if (kAppdelegate.isOnline == NO) {
//        //在window上弹出提示,告知用户无网络
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppdelegate.window animated:YES];
//        //纯文本模式
//        hud.mode = MBProgressHUDModeIndeterminate;
//        //设置文字
//        hud.label.text = @"无网络,请稍后重试";
//        //设置弹出时间
//        [hud hideAnimated:YES afterDelay:1];
//        
//        
//        
//        //userInfo中的值,会自动存入error的localizedDescription属性中
//        NSError *error = [NSError errorWithDomain:path code:1234 userInfo:@{NSLocalizedDescriptionKey: @"无网络"}];
////        error.localizedDescription
//        completionHandle(nil, error);
//        return nil;
//    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
    return [manager GET:path parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, error);
    }];
}
+ (id)POST:(NSString *)path parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress completionHandle:(void (^)(id, NSError *))completionHandle{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
    return [manager GET:path parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, error);
    }];
}
@end
