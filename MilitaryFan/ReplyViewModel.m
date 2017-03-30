//
//  ReplyViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReplyViewModel.h"

@implementation ReplyViewModel
#pragma mark - 评论详情
- (instancetype)initWithModel:(AllCommentsModel *)model{
    if (self = [super init]) {
        self.commentModel = model;
    }
    return self;
}
- (AllCommentsModel *)commentModel{
    if (_commentModel == nil) {
        _commentModel = [[AllCommentsModel alloc] init];
    }
    return _commentModel;
}
- (NSString *)commentId{
    return self.commentModel.objectId;
}
- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.commentModel.headImageURL];
}
- (NSString *)commentName{
    return self.commentModel.userName;
}
- (NSString *)commentlocation{
    return self.commentModel.location;
}
- (NSString *)commentTime{
    return self.commentModel.createDate;
}
- (NSString *)commentContent{
    return self.commentModel.comment;
}
- (NSString *)likeNumber{
    return [@(self.commentModel.likeNumber) stringValue];
}
- (NSString *)replyNumber{
    return [@(self.commentModel.replyNumber) stringValue];
}
#pragma mark - 回复详情
- (NSMutableArray<ReplyModel *> *)replyList{
    if (_replyList == nil) {
        _replyList = [NSMutableArray array];
    }
    return _replyList;
}
- (NSInteger)replyListNumber{
    return self.replyList.count;
}
- (ReplyModel *)modelForRow:(NSInteger)row{
    return [self.replyList objectAtIndex:row];
}
- (NSString *)replyNameForRow:(NSInteger)row{
    return [NSString stringWithFormat:@"%@:", [self modelForRow:row].userName];
}
- (NSString *)replyTimeForRow:(NSInteger)row{
    return [Factory timeIntervalStringSinceCurrentDate:[self modelForRow:row].createdAt];
}
- (NSString *)replyContentForRow:(NSInteger)row{
    return [self modelForRow:row].content;
}
- (void)getAllReplyWithCommentId:(NSString *)commentId completionHandler:(void (^)(NSError *))completionHandler{
    BmobQuery *replyQuery = [BmobQuery queryWithClassName:@"Reply"];
    replyQuery.limit = 20;
    [replyQuery whereKey:@"commentId" equalTo:commentId];
//    [replyQuery andOperation];
    [replyQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.replyList removeAllObjects];
            for (BmobObject *replyObj in array) {
                ReplyModel *model = [[ReplyModel alloc] init];
                model.userName = [replyObj objectForKey:@"userName"];
                model.createdAt = replyObj.createdAt;
                model.content = [replyObj objectForKey:@"content"];
                [self.replyList addObject:model];
            }
            completionHandler(nil);
        } else {
            NSLog(@"error: %@", error);
            completionHandler(error);
        }
    }];
    
}
@end
