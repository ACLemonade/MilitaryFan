//
//  ReplyViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReplyViewModel.h"

@implementation ReplyViewModel
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
@end
