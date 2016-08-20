//
//  NSObject+AFNetworking.h
//  day08_Beauty
//
//  Created by Lemonade on 16/8/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#define kCompletionHandleBlock (void(^)(id model, NSError *error))completionHandle;

typedef void(^CompletionHandleBlock)(id model, NSError *error);

@interface NSObject (AFNetworking)

+ (id)GET:(NSString *)path parameters:(id)parameters progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandle:(void(^)(id responseObj, NSError *error))completionHandle;

+ (id)POST:(NSString *)path parameters:(id)parameters progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandle:(void(^)(id responseObj, NSError *error))completionHandle;
@end
