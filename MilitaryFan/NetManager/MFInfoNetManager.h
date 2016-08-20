//
//  MFInfoNetManager.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AFNetworking.h"

#import "MFInfoPath.h"

#import "MFInfoModel.h"

typedef NS_ENUM(NSUInteger, InfoType) {
    InfoTypeRecommend,
    InfoTypeRankList,
    InfoTypeTop,
};

@interface MFInfoNetManager : NSObject
+ (id)getMFInfoWithType:(InfoType)infoType currentPage:(NSInteger)currentPage completionHandle:kCompletionHandleBlock
@end
