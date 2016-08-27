//
//  MFInfoNetManager.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFInfoNetManager.h"

@implementation MFInfoNetManager
+ (id)getMFInfoWithType:(InfoType)infoType currentPage:(NSInteger)currentPage completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = nil;
    switch (infoType) {
        case InfoTypeRecommend:
            path = [NSString stringWithFormat:kRecommendPath, currentPage];
            break;
            case InfoTypeRankList:
            path = [NSString stringWithFormat:kRankListPath, currentPage];
            break;
            case InfoTypeTop:
            path = [NSString stringWithFormat:kTopPath, currentPage];
            break;
            case InfoTypePicture:
            path = [NSString stringWithFormat:kPicturePath, currentPage];
            break;
            case InfoTypeBigWide:
            path = [NSString stringWithFormat:kBigWidePath, currentPage];
            break;
            case InfoTypeHistory:
            path = [NSString stringWithFormat:kHistoryPath, currentPage];
            break;
        default:
            break;
    }
    return [self GET:path parameters:nil progress:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([MFInfoModel parse:responseObj], error);
    }];
}
+ (id)getDetailWithAid:(NSString *)aid completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = [NSString stringWithFormat:kDetailPath, aid];
    return [self GET:path parameters:nil progress:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([MFDetailModel parse:responseObj], error);
    }];
}
+ (id)getPicWithAid:(NSString *)aid completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = [NSString stringWithFormat:kPicDetailPath, aid];
    return [self GET:path parameters:nil progress:nil completionHandle:^(id responseObj, NSError *error) {
        completionHandle([MFPicModel parse:responseObj], error);
    }];
}
@end
