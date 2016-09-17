//
//  CollectionModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel
- (instancetype)init{
    if (self = [super init]) {
        [self dbUpdate];
    }
    return self;
}
- (NSMutableArray<CollectionDetailModel *> *)collectionList{
    if (_collectionList == nil) {
        _collectionList = [NSMutableArray<CollectionDetailModel *> array];
    }
    return _collectionList;
}
- (void)dbUpdate{
    [self.collectionList removeAllObjects];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDataBasePath];
    [queue inDatabase:^(FMDatabase *db) {
        self.collectionNumber = [db intForQuery:@"select count(*) from Collection"];
        FMResultSet *result = [db executeQuery:@"select * from Collection"];
        while ([result next]) {
            CollectionDetailModel *model = [CollectionDetailModel new];
            model.aid = [result stringForColumn:@"Aid"];
            model.type = [result longForColumn:@"Type"];
            model.image = [result stringForColumn:@"Image"];
            model.title = [result stringForColumn:@"Title"];
            model.pubDate = [result stringForColumn:@"PubDate"];
            [self.collectionList addObject:model];
        }
    }];

}
@end
@implementation CollectionDetailModel

@end