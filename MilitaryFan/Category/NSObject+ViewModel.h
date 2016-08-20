//
//  NSObject+ViewModel.h
//  CarHome
//
//  Created by Lemonade on 16/8/15.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RequestRefresh,
    RequestGetMore,
} RequestType;

@interface NSObject (ViewModel)
//用于保存当前的网络请求
@property (nonatomic) NSURLSessionDataTask *dataTask;
//取消任务
- (void)cancelTask;
//暂停任务
- (void)suspendTask;
//继续任务
- (void)resumeTask;

- (void)getDataWithMode:(RequestType)mode completionHandle:(void(^)(NSError *error))completionHandle;
@end
