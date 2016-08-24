//
//  MFVideoModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFVideoModel.h"

@implementation MFVideoModel

@end
@implementation MFVideoDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"item" : [MFVideoItemModel class]};
}

@end


@implementation MFVideoTitleModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"typeName": @"typename",
             @"desc": @"description"
             };
}
@end


@implementation MFVideoItemModel

@end


