//
//  ReplyViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllCommentsModel.h"
#import "ReplyModel.h"

@interface ReplyViewModel : NSObject
#pragma mark - 评论详情
/** 初始化viewModel,由上一个界面传参,无需网络请求,节省流量 */
- (instancetype)initWithModel:(AllCommentsModel *)model;

@property (nonatomic, strong) AllCommentsModel *commentModel;
/** 评论Id */
@property (nonatomic, strong) NSString *commentId;
/** 头像 */
@property (nonatomic, strong) NSURL *headImageURL;
/** 评论者昵称 */
@property (nonatomic, strong) NSString *commentName;
/** 评论地点 */
@property (nonatomic, strong) NSString *commentlocation;
/** 评论时间 */
@property (nonatomic, strong) NSString *commentTime;
/** 评论内容 */
@property (nonatomic, strong) NSString *commentContent;
/** 点赞个数 */
@property (nonatomic, assign) NSString *likeNumber;
/** 回复个数 */
@property (nonatomic, assign) NSString *replyNumber;
#pragma mark - 回复详情
@property (nonatomic, strong) NSMutableArray<ReplyModel *> *replyList;
@property (nonatomic, assign) NSInteger replyListNumber;

- (ReplyModel *)modelForRow:(NSInteger)row;
/** 回复者昵称 */
- (NSString *)replyNameForRow:(NSInteger)row;
/** 回复时间 */
- (NSString *)replyTimeForRow:(NSInteger)row;
/** 回复内容 */
- (NSString *)replyContentForRow:(NSInteger)row;
/** 根据评论Id获取回复列表 */
- (void)getAllReplyWithCommentId:(NSString *)commentId completionHandler:(void(^)(NSError *error))completionHandler;
@end
