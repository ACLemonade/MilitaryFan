//
//  MFVideoNetManager.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AFNetworking.h"

#import "MFInfoPath.h"

#import "MFVideoModel.h"
#import "MFVideoDetailModel.h"

@interface MFVideoNetManager : NSObject
+ (id)getMFVideoWithCurrentPage:(NSInteger)currentPage completionHandle:kCompletionHandleBlock;
+ (id)getMFVideoDetailWithAid:(NSString *)aid completionHandle:kCompletionHandleBlock;
@end
