//
//  MFVideoViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFVideoViewModel.h"

@implementation MFVideoViewModel
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    if (self = [super init]) {
        self.currentPage = 1;
    }
    return self;
}
- (NSMutableArray<MFVideoItemModel *> *)itemList{
    if (_itemList == nil) {
        _itemList = [NSMutableArray array];
    }
    return _itemList;
}
- (NSInteger)itemNumber{
    return self.itemList.count;
}

#pragma mark - 方法 Methods
- (NSURL *)iconURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].image];
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self modelForRow:row].title;
}
- (NSString *)authorForRow:(NSInteger)row{
    return [self modelForRow:row].author;
}
- (NSString *)pubDateForRow:(NSInteger)row{
    return [self modelForRow:row].pubDate;
}

- (MFVideoItemModel *)modelForRow:(NSInteger)row{
    return [self.itemList objectAtIndex:row];
}
- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    NSInteger tmpPage = 0;
    switch (mode) {
        case RequestRefresh:
            tmpPage = 1;
            break;
        case RequestGetMore:
            tmpPage = _currentPage + 1;
        default:
            break;
    }
    self.dataTask = [MFVideoNetManager getMFVideoWithCurrentPage:tmpPage completionHandle:^(MFVideoModel *model, NSError *error) {
        if (!error) {
            if (!mode) {
                [self.itemList removeAllObjects];
            }
            [self.itemList addObjectsFromArray:model.data.item];
        }
        completionHandle(error);
        _currentPage = tmpPage;
    }];
}
@end
