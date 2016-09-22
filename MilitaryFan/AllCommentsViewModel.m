//
//  AllCommentsViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsViewModel.h"

@implementation AllCommentsViewModel
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
   NSString *date = [self modelForRow:row].createDate;
    return date;
}
- (NSString *)commentForRow:(NSInteger)row{
    return [self modelForRow:row].comment;
}
- (AllCommentsDetailModel *)modelForRow:(NSInteger)row{
    return [self.commentList objectAtIndex:row];
}
//评论个数
- (NSInteger)commentNumber{
    return self.commentList.count;
}
//评论内容高度
- (CGFloat)commentHeightForRow:(NSInteger)row{
    NSString *comment = [self commentForRow:row];
    CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(kScreenW - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    //15+title高度(20)+15+label高度+15+评论时间高度(17)+15
    CGFloat totalHeight = commentSize.height + 97;
    return totalHeight;
}
- (AllCommentsModel *)allCommentsModel{
    if (_allCommentsModel == nil) {
        _allCommentsModel = [[AllCommentsModel alloc] init];
    }
    return _allCommentsModel;
}
- (void)commentUpdateWithComplationHandle:(void(^)(NSArray * array))completionHandle{
    [self.allCommentsModel dbUpdateWithCompletionHandle:^(NSArray<AllCommentsDetailModel *> *array) {
        self.commentList = array;
        completionHandle(self.commentList);
    }];
}
@end
