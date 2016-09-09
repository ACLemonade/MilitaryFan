//
//  AllCommentsModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsModel.h"

@implementation AllCommentsModel
- (instancetype)init{
    if (self = [super init]) {
        [self dbUpdate];
    }
    return self;
}
- (NSMutableArray<AllCommentsDetailModel *> *)commentList {
    if(_commentList == nil) {
        _commentList = [NSMutableArray<AllCommentsDetailModel *> array];
    }
    return _commentList;
}
- (void)dbUpdate{
    NSDictionary *detailDic = [NSDictionary dictionaryWithContentsOfFile:kDetailPlistPath];
    NSString *aid = [detailDic objectForKey:@"Aid"];
    NSInteger detailType = [[detailDic objectForKey:@"Type"] integerValue];
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    query.limit = 20;
    [query addTheConstraintByAndOperationWithArray:@[@{@"Aid": aid}, @{@"Type": @(detailType)}]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.firstObject) {
            for (BmobObject *obj in array) {
                AllCommentsDetailModel *model = [AllCommentsDetailModel new];
                model.headImageURL = [obj objectForKey:@"headImageURL"];
                model.userName = [obj objectForKey:@"userName"];
                model.comment = [obj objectForKey:@"comment"];
                model.createDate = [obj objectForKey:@"createdAt"];
                model.location = [obj objectForKey:@"location"];
                [self.commentList addObject:model];
//                NSLog(@"数据库查询");
            }
        }
    }];
}
@end
@implementation AllCommentsDetailModel



@end