//
//  CacheManager.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/8.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
//---- 首页归解档 ----/
+ (BOOL)archiveMFInfoWithVM:(MFInfoViewModel *)viewModel{
    return [NSKeyedArchiver archiveRootObject:viewModel toFile:[self archivePathWithType:viewModel.infoType]];
}
+ (MFInfoViewModel *)unArchiveMFInfoWithType:(InfoType)type{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathWithType:type]];
}
+ (NSString *)archivePathWithType:(InfoType)type{
    return [kInfoCachePath stringByAppendingPathComponent:@(type).stringValue];
}
//---- 首页归解档 ----/

//---- 详情页归解档 ----/
+ (BOOL)archiveMFDetailWithVM:(id)viewModel{
    //图片详情页
    if ([viewModel isKindOfClass:[MFPicViewModel class] ]) {
        return [NSKeyedArchiver archiveRootObject:(MFPicViewModel *)viewModel toFile:[self archivePathWithAid:((MFPicViewModel *)viewModel).aid]];
    }
    //视频详情页
    if ([viewModel isKindOfClass:[MFVideoDetailViewModel class] ]) {
        return [NSKeyedArchiver archiveRootObject:(MFVideoDetailViewModel *)viewModel toFile:[self archivePathWithAid:((MFVideoDetailViewModel *)viewModel).aid]];
    }
    //普通详情页
    return [NSKeyedArchiver archiveRootObject:(MFDetailViewModel *)viewModel toFile:[self archivePathWithAid:((MFDetailViewModel *)viewModel).aid]];
    
}
//普通详情页
+ (MFDetailViewModel *)unArchiveMFDetailWithAid:(NSString *)aid{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathWithAid:aid]];
}
//图片详情页
+ (MFPicViewModel *)unArchiveMFPicWithAid:(NSString *)aid{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathWithAid:aid]];
}
//视频详情页
+ (MFVideoDetailViewModel *)unArchiveMFVideoWithAid:(NSString *)aid{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathWithAid:aid]];
}
+ (NSString *)archivePathWithAid:(NSString *)aid{
    return [kDetailCachePath stringByAppendingPathComponent:aid];
}
//---- 详情页归解档 ----/
@end
