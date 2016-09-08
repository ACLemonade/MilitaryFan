//
//  MFDetailViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFDetailViewModel.h"
#import "CacheManager.h"

@implementation MFDetailViewModel
kLemonadeArchive
- (instancetype)init{
    NSAssert(NO, @"%s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
        id obj = [CacheManager unArchiveMFDetailWithAid:aid];
        if (obj) {
            self = obj;
        }
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
- (NSArray *)pics{
    return self.model.pics;
}
- (NSArray<NSString *> *)content{
    return self.model.content;
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
    [MFInfoNetManager getDetailWithAid:self.aid completionHandle:^(MFDetailModel *model, NSError *error) {
        if (!error) {
            self.model = model.data;
            [CacheManager archiveMFDetailWithVM:self];
        }
        completionHandle(error);
    }];
    
}
@end
