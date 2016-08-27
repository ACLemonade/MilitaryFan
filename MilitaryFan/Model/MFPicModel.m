//
//  MFPicModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFPicModel.h"

@implementation MFPicModel

@end


@implementation MFPicDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"pics" : [MFPicPicsModel class], @"relations" : [MFPicRelationsModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc": @"description"
             };
}
@end


@implementation MFPicAdd_CodeModel

@end


@implementation MFPicCommentsModel

@end


@implementation MFPicPicsModel

@end


@implementation MFPicRelationsModel

@end


