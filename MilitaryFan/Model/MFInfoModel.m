//
//  MFInfoModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFInfoModel.h"

@implementation MFInfoModel

@end
@implementation MFDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"nav" : [MFNavModel class], @"slide" : [MFSlideModel class], @"item" : [MFItemModel class]};
}

@end


@implementation MFTitleModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"typeName": @"typename",
             @"desc": @"decription"
             };
}
@end


@implementation MFNavModel

@end


@implementation MFSlideModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc": @"decription"
             };
}
@end


@implementation MFItemModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc": @"decription"
             };
}
@end


