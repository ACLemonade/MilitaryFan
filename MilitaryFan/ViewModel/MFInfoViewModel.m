//
//  MFInfoViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFInfoViewModel.h"

@implementation MFInfoViewModel
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"%s", __func__);
    return nil;
}
- (instancetype)initWithInfoType:(InfoType)infoType{
    if (self = [super init]) {
        self.infoType = infoType;
        self.currentPage = 1;
    }
    return self;
}
- (NSInteger)topNumber{
    return self.topList.count;
}
- (BOOL)isHasTop{
    return self.topNumber;
}
- (NSArray<MFSlideModel *> *)topList{
    if (_topList == nil) {
        _topList = [[NSArray alloc] init];
    }
    return _topList;
}
- (NSInteger)itemNumber{
    return self.itemList.count;
}
- (NSMutableArray<MFItemModel *> *)itemList{
    if (_itemList == nil) {
        _itemList = [NSMutableArray array];
    }
    return _itemList;
}
#pragma mark - 方法 Methods
- (MFSlideModel *)topModelForIndex:(NSInteger)index{
    return [self.topList objectAtIndex:index];
}
- (MFItemModel *)itemModelForRow:(NSInteger)row{
    return [self.itemList objectAtIndex:row];
}

- (NSURL *)topIconURLForIndex:(NSInteger)index{
    MFSlideModel *model = [self topModelForIndex:index];
    return [NSURL URLWithString:model.image];
}
- (NSString *)topTitleForIndex:(NSInteger)index{
    return [self topModelForIndex:index].title;
}

- (NSURL *)itemIconURLForRow:(NSInteger)row{
    MFItemModel *model = [self itemModelForRow:row];
    return [NSURL URLWithString:model.image];
}
- (NSString *)itemTitleForRow:(NSInteger)row{
    return [self itemModelForRow:row].title;
}
- (NSString *)itemPubDateForRow:(NSInteger)row{
    return [self itemModelForRow:row].pubDate;
}
- (NSString *)itemAuthorForRow:(NSInteger)row{
    return [self itemModelForRow:row].author;
}
- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    NSInteger tmpPage;
    switch (mode) {
        case RequestRefresh:
            tmpPage = 1;
            break;
        case RequestGetMore:
            tmpPage = _currentPage + 1;
        default:
            break;
    }
    [MFInfoNetManager getMFInfoWithType:self.infoType currentPage:tmpPage completionHandle:^(MFInfoModel *model, NSError *error) {
        if (!error) {
            if (!mode) {
                [self.itemList removeAllObjects];
            }
            self.topList = model.data.slide;
            [self.itemList addObjectsFromArray:model.data.item];
        }
        completionHandle(error);
        _currentPage = tmpPage + 1;
    }];
    
}
@end
