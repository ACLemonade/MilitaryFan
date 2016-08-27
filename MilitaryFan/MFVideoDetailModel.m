//
//  MFVideoDetailModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFVideoDetailModel.h"

@implementation MFVideoDetailModel


@end


@implementation MFVideoDetailDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc": @"description",
             @"videoPlay": @"video_play"
             };
}
@end


@implementation MFVideoDetailAdd_CodeModel

@end


@implementation MFVideoDetailCommentsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MFVideoDetailListModel class]};
}

@end


@implementation MFVideoDetailListModel

@end


