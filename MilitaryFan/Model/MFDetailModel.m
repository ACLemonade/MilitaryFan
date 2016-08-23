//
//  MFDetailModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFDetailModel.h"

@implementation MFDetailModel

@end
@implementation MFDetailDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc": @"description"
             };
}
@end


@implementation MFDetailAdd_CodeModel

@end


@implementation MFDetailCommentsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MFDetailListModel class]};
}

@end


@implementation MFDetailListModel

@end


