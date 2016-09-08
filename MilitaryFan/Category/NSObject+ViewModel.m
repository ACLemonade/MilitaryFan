//
//  NSObject+ViewModel.m
//  CarHome
//
//  Created by Lemonade on 16/8/15.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "NSObject+ViewModel.h"
//通过运行时,解决Category不能定义属性的弱点
#import <objc/runtime.h>
//dataTaskKey变量存的是它自己的地址,因为是静态的,所以地址不会有重复
static const void *dataTaskKey = &dataTaskKey;
@implementation NSObject (ViewModel)
//通过运行时,动态绑定实现属性的setter方法
- (void)setDataTask:(NSURLSessionDataTask *)dataTask{
    //参数4:属性的内存管理方式 ARC:strong MRC:retain
    objc_setAssociatedObject(self, dataTaskKey, dataTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//通过运行时,动态绑定实现属性的getter方法
- (NSURLSessionDataTask *)dataTask{
    return objc_getAssociatedObject(self, dataTaskKey);
}

- (void)cancelTask{
    [self.dataTask cancel];
}
- (void)suspendTask{
    [self.dataTask suspend];
}
- (void)resumeTask{
    [self.dataTask resume];
}
- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{}
@end
