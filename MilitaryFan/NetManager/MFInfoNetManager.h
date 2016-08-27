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
#import "MFDetailModel.h"
#import "MFPicModel.h"

typedef NS_ENUM(NSUInteger, InfoType) {
    InfoTypeRecommend,
    InfoTypeRankList,
    InfoTypeTop,
    InfoTypePicture,
    InfoTypeBigWide,
    InfoTypeHistory
};

@interface MFInfoNetManager : NSObject
//第一页
+ (id)getMFInfoWithType:(InfoType)infoType currentPage:(NSInteger)currentPage completionHandle:kCompletionHandleBlock
//详情页
+ (id)getDetailWithAid:(NSString *)aid completionHandle:kCompletionHandleBlock;
//详情页--图片
+ (id)getPicWithAid:(NSString *)aid completionHandle:kCompletionHandleBlock;
@end
