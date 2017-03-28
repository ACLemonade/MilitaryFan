//
//  AllCommentsViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllCommentsModel.h"
@interface AllCommentsViewModel : NSObject
/** 评论个数 */
@property (nonatomic) NSInteger commentNumber;

@property (nonatomic) NSMutableArray<AllCommentsModel *> *commentList;

@property (nonatomic) AllCommentsModel *allCommentsModel;
/** 评论Id */
- (NSString *)commentIdForRow:(NSInteger)row;
/** 头像 */
- (NSURL *)iconURLForRow:(NSInteger)row;
/** 评论者昵称 */
- (NSString *)userNameForRow:(NSInteger)row;
/** 评论地点 */
- (NSString *)userLocationForRow:(NSInteger)row;
/** 评论时间 */
- (NSString *)createDateForRow:(NSInteger)row;
/** 评论内容 */
- (NSString *)commentForRow:(NSInteger)row;
/** 点赞状态 */
- (BOOL)likeStateForRow:(NSInteger)row;
/** 点赞数 */
- (NSString *)likeNumberForRow:(NSInteger)row;
/** 评论内容(label)高度 */
- (CGFloat)commentHeightForRow:(NSInteger)row;

- (AllCommentsModel *)modelForRow:(NSInteger)row;

- (void)getAllCommentWithCompletionHandler:(void(^)(NSError *error))completionHandler;
@end
