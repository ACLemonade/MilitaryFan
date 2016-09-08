//
//  MFPicViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFPicViewModel.h"

@implementation MFPicViewModel
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"必须使用initWithAid方法进行初始化 %s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}
- (NSInteger)picNumber{
    return self.picList.count;
}
#pragma mark - 方法 Methods
- (NSURL *)iconURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:[self modelForIndex:index].url];
}
- (NSString *)pictextForIndex:(NSInteger)index{
    return [self modelForIndex:index].picstext;
}
- (MFPicPicsModel *)modelForIndex:(NSInteger)index{
    return [self.picList objectAtIndex:index];
}
- (NSString *)pubDate{
    return self.picDataModel.pubDate;
}
//分享
- (NSString *)title{
    return self.picDataModel.title;
}
- (NSString *)desc{
    return self.picDataModel.desc;
}
- (NSString *)image{
    return self.picDataModel.image;
}
- (NSString *)link{
    return self.picDataModel.link;
}
- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    self.dataTask = [MFInfoNetManager getPicWithAid:self.aid completionHandle:^(MFPicModel *model, NSError *error) {
        if (!error) {
            self.picList = model.data.pics;
            //分享需要
            self.picDataModel = model.data;
        }
        completionHandle(error);
    }];
}
@end
