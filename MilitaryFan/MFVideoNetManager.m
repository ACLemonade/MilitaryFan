//
//  MFVideoNetManager.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFVideoNetManager.h"

@implementation MFVideoNetManager
+ (id)getMFVideoWithCurrentPage:(NSInteger)currentPage completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = [NSString stringWithFormat:kVideoPath, currentPage];
    return [self GET:path parameters:nil progress:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([MFVideoModel parse:responseObj], error);
    }];
}
@end
