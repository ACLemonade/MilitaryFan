//
//  AllCommentsViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsViewModel.h"

@implementation AllCommentsViewModel
- (NSString *)iconIVForRow:(NSInteger)row{
    return nil;
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
- (NSInteger)commentNumber{
    return self.commentList.count;
}
- (NSArray<AllCommentsDetailModel *> *)commentList{
    if (_commentList == nil) {
        _commentList = self.allCommentsModel.commentList;
    }
    return _commentList;
}
- (AllCommentsModel *)allCommentsModel {
    if(_allCommentsModel == nil) {
        _allCommentsModel = [[AllCommentsModel alloc] init];
    }
    return _allCommentsModel;
}
- (void)commentUpdate{
    [self.allCommentsModel dbUpdate];
}
@end
