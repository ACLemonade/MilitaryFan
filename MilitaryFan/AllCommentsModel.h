//
//  AllCommentsModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class AllCommentsDetailModel;

@interface AllCommentsModel : BaseModel
/** 评论Id */
@property (nonatomic, strong) NSString *objectId;
/** 头像 */
@property (nonatomic) NSString *headImageURL;
/** 评论者昵称 */
@property (nonatomic) NSString *userName;
/** 评论内容 */
@property (nonatomic) NSString *comment;
/** 评论时间 */
@property (nonatomic) NSString *createDate;
/** 评论地点 */
@property (nonatomic) NSString *location;
/** 点赞个数 */
@property (nonatomic, assign) NSInteger likeNumber;
/** 回复个数 */
@property (nonatomic, assign) NSInteger replyNumber;
/** 举报个数 */
@property (nonatomic, assign) NSInteger reportNumber;
@end
