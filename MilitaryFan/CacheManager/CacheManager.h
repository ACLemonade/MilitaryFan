//
//  CacheManager.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/8.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFInfoNetManager.h"

#import "MFInfoViewModel.h"
#import "MFVideoViewModel.h"

#import "MFDetailViewModel.h"
#import "MFPicViewModel.h"
#import "MFVideoDetailViewModel.h"

@interface CacheManager : NSObject
//首页归档
+ (BOOL)archiveMFInfoWithVM:(MFInfoViewModel *)viewModel;
//首页解档
+ (MFInfoViewModel *)unArchiveMFInfoWithType:(InfoType)type;
//视频页归档
+ (BOOL)archiveMFVideoWithVM:(MFVideoViewModel *)viewModel;
//视频页解档
+(MFVideoViewModel *)unArchiveMFVideo;
//详情页归档
+ (BOOL)archiveMFDetailWithVM:(id)viewModel;
//详情页解档
+ (MFDetailViewModel *)unArchiveMFDetailWithAid:(NSString *)aid;
+ (MFPicViewModel *)unArchiveMFPicWithAid:(NSString *)aid;
+ (MFVideoDetailViewModel *)unArchiveMFVideoWithAid:(NSString *)aid;
@end
