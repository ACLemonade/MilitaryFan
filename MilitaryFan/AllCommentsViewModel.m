//
//  AllCommentsViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsViewModel.h"

@interface AllCommentsViewModel ()
- (void)getAllCommentWithoutHeadImageWithCompletionHandler:(void(^)(NSArray *userNameArray, NSError *error))completionHandler;
@end

@implementation AllCommentsViewModel
//评论个数
- (NSInteger)commentNumber{
    return self.commentList.count;
}
- (NSMutableArray<AllCommentsModel *> *)commentList{
    if (_commentList == nil) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}
- (AllCommentsModel *)modelForRow:(NSInteger)row{
    return [self.commentList objectAtIndex:row];
}
- (NSString *)commentIdForRow:(NSInteger)row{
    return [self modelForRow:row].objectId;
}
- (NSURL *)iconURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].headImageURL];
}
- (NSString *)userNameForRow:(NSInteger)row{
    return [self modelForRow:row].userName;
}
- (NSString *)userLocationForRow:(NSInteger)row{
    return [self modelForRow:row].location;
}
- (NSString *)createDateForRow:(NSInteger)row{
   NSString *date = SUB_TIME([self modelForRow:row].createDate);
    return date;
}
- (NSString *)commentForRow:(NSInteger)row{
    return [self modelForRow:row].comment;
}
- (NSString *)likeNumberForRow:(NSInteger)row{
    return [@([self modelForRow:row].likeNumber) stringValue];
}
- (NSString *)revealReplyTitleForRow:(NSInteger)row{
    NSInteger replyNumber = [self modelForRow:row].replyNumber;
    return replyNumber == 0 ? @"点击回复" : [NSString stringWithFormat:@"查看%ld条回复", replyNumber];
}
//评论内容高度
- (CGFloat)commentHeightForRow:(NSInteger)row{
    NSString *comment = [self commentForRow:row];
    CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(kScreenW - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    //15+title高度(20)+15+label高度+15+评论时间高度(17)+15
    CGFloat totalHeight = commentSize.height + 97;
    return totalHeight;
}
- (void)getAllCommentWithoutHeadImageWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler{
    NSDictionary *detailDic = [NSDictionary dictionaryWithContentsOfFile:kDetailPlistPath];
    NSString *aid = [detailDic objectForKey:@"Aid"];
    NSInteger detailType = [[detailDic objectForKey:@"Type"] integerValue];
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    query.limit = 20;
    [query addTheConstraintByAndOperationWithArray:@[@{@"Aid": aid}, @{@"Type": @(detailType)}]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.commentList removeAllObjects];
            NSMutableArray *userNameArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                AllCommentsModel *model = [[AllCommentsModel alloc] init];
//                model.headImageURL = [obj objectForKey:@"headImageURL"];
                model.objectId = obj.objectId;
                model.userName = [obj objectForKey:@"userName"];
                model.comment = [obj objectForKey:@"comment"];
                model.createDate = [obj objectForKey:@"createdAt"];
                model.location = [obj objectForKey:@"location"];
                model.likeNumber = [[obj objectForKey:@"likeNumber"] integerValue];
                model.replyNumber = [[obj objectForKey:@"replyNumber"] integerValue];
                [self.commentList addObject:model];
                [userNameArray addObject:model.userName];
            }
            completionHandler(userNameArray, nil);
        } else {
            completionHandler(nil, error);
        }
    }];
}
- (void)getAllCommentWithCompletionHandler:(void (^)(NSError *))completionHandler{
    [self getAllCommentWithoutHeadImageWithCompletionHandler:^(NSArray *userNameArray, NSError *error) {
        if (!error) {
            BmobQuery *userQuery = [BmobQuery queryWithClassName:@"UserInfo"];
            [userQuery selectKeys:@[@"userName", @"headImageURL"]];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    for (int i = 0; i < userNameArray.count; i++) {
                        NSString *userName = [userNameArray objectAtIndex:i];
                        for (BmobObject *userObj in array) {
                            if ([userName isEqualToString:[userObj objectForKey:@"userName"]]) {
                                AllCommentsModel *model = [self.commentList objectAtIndex:i];
                                model.headImageURL = [userObj objectForKey:@"headImageURL"];
                            }
                        }
                    }
                    completionHandler(nil);
                } else {
                    completionHandler(error);
                }
            }];
        } else {
            completionHandler(error);
        }
    }];
}
@end
