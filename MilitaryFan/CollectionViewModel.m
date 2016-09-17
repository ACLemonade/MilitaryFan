//
//  CollectionViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CollectionViewModel.h"
@implementation CollectionViewModel

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (CollectionModel *)collectionModel{
    if (_collectionModel == nil) {
        _collectionModel = [[CollectionModel alloc] init];
    }
    return _collectionModel;
}
- (NSMutableArray<CollectionDetailModel *> *)itemList{
    //在懒加载的情况下无法实时更新数据
    return self.collectionModel.collectionList;
}
- (CollectionDetailModel *)detailModelForRow:(NSInteger)row{
    return [self.itemList objectAtIndex:row];
}
- (NSInteger)itemNumber{
    return self.collectionModel.collectionNumber;
}
- (NSURL *)iconURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self detailModelForRow:row].image];
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self detailModelForRow:row].title;
}
- (NSString *)pubDateForRow:(NSInteger)row{
    return [self detailModelForRow:row].pubDate;
}
- (NSString *)aidForRow:(NSInteger)row{
    return [self detailModelForRow:row].aid;
}
- (NSInteger)typeForRow:(NSInteger)row{
    return [self detailModelForRow:row].type;
}
- (void)collectionUpdate{
    [self.collectionModel dbUpdate];
}
@end
