//
//  ReplyModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/30.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
/** 回复Id */
@property (nonatomic, strong) NSString *objectId;
/** 回复者昵称 */
@property (nonatomic, strong) NSString *userName;
/** 回复内容 */
@property (nonatomic, strong) NSString *content;
/** 被回复的评论者昵称 */
@property (nonatomic, strong) NSString *commentName;
/** 被回复的评论Id */
@property (nonatomic, strong) NSString *commentId;
/** 被回复的新闻Id */
@property (nonatomic, strong) NSString *Aid;
/** 创建时间 */
@property (nonatomic, strong) NSDate *createdAt;
/** 更新时间 */
@property (nonatomic, strong) NSDate *updatedAt;
@end
