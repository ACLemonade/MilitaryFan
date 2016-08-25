//
//  MFDetailViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFDetailViewModel.h"

@implementation MFDetailViewModel
- (instancetype)init{
    NSAssert(NO, @"%s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid detailType:(NSInteger)detailType{
    if (self = [super init]) {
        self.aid = aid;
        self.detailType = detailType;
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



- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    [MFInfoNetManager getDetailWithAid:self.aid detailType:self.detailType completionHandle:^(MFDetailModel *model, NSError *error) {
        if (!error) {
            self.model = model.data;
        }
        completionHandle(error);
    }];
    
}
@end
