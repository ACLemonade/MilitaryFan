//
//  AllCommentsModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsModel.h"

@interface AllCommentsModel ()
@property (nonatomic) NSMutableArray<AllCommentsDetailModel *> *commentList;
@end
@implementation AllCommentsModel

- (NSMutableArray<AllCommentsDetailModel *> *)commentList {
    if(_commentList == nil) {
        _commentList = [NSMutableArray<AllCommentsDetailModel *> array];
    }
    return _commentList;
}
- (void)dbUpdateWithCompletionHandle:(void(^)(NSArray<AllCommentsDetailModel *> * array))completionHandle{
    NSDictionary *detailDic = [NSDictionary dictionaryWithContentsOfFile:kDetailPlistPath];
    NSString *aid = [detailDic objectForKey:@"Aid"];
    NSInteger detailType = [[detailDic objectForKey:@"Type"] integerValue];
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    query.limit = 20;
    [query addTheConstraintByAndOperationWithArray:@[@{@"Aid": aid}, @{@"Type": @(detailType)}]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.firstObject) {
            [self.commentList removeAllObjects];
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
            completionHandle([self.commentList copy]);
        }
    }];
}
@end
@implementation AllCommentsDetailModel



@end