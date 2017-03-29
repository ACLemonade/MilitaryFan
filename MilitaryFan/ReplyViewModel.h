//
//  ReplyViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllCommentsModel.h"

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
@end
