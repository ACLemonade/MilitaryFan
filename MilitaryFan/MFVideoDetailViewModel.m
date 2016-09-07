//
//  MFVideoDetailViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFVideoDetailViewModel.h"

@implementation MFVideoDetailViewModel
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"必须使用initWithAid方法进行初始化, %s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}
- (NSString *)title{
    return self.model.title;
}
- (NSString *)pubDate{
    return self.model.pubDate;
}
- (NSString *)author{
    return self.model.author;
}
- (NSString *)click{
    return self.model.click;
}
- (NSURL *)videoPlay{
    return [NSURL URLWithString:self.model.videoPlay];
}
- (NSURL *)iconIV{
    return [NSURL URLWithString:self.model.image];
}
- (NSString *)image{
    return self.model.image;
}
- (NSString *)link{
    return self.model.link;
}
- (NSString *)desc{
    return self.model.desc;
}
- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    self.dataTask = [MFVideoNetManager getMFVideoDetailWithAid:self.aid completionHandle:^(MFVideoDetailModel *model, NSError *error) {
        if (!error) {
            self.model = model.data;
        }
        completionHandle(error);
    }];
}

@end
