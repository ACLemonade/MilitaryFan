//
//  QuestionModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"
#import "BaseModel.h"

@interface QuestionModel : BaseModel
/** 提问者 */
@property (nonatomic, strong) NSString *askName;
/** 提问者头像 */
@property (nonatomic, strong) NSString *headImageURL;
/** 提问者位置 */
@property (nonatomic, strong) NSString *location;
/** 问题内容 */
@property (nonatomic, strong) NSString *question;
/** 问题类型 10:普通问题,11:积分悬赏 */
@property (nonatomic, assign) NSInteger Type;
/** 保留字段,暂无用处 */
@property (nonatomic, strong) NSString *Aid;
/** 解决状态 */
@property (nonatomic, assign) BOOL resolvedState;
/** 悬赏积分 普通问题为0,不可修改;积分问题可修改 */
@property (nonatomic, assign) NSInteger rewardScore;
/** 回答数量 */
@property (nonatomic, assign) NSInteger answerNumber;
/** 问题最终采纳人 */
@property (nonatomic, strong) NSString *answerName;
/** 问题id */
@property (nonatomic, strong) NSString *objectId;
/** 问题创建时间 */
@property (nonatomic, strong) NSString *createdAt;
/** 问题更新时间 */
@property (nonatomic, strong) NSString *updatedAt;
///** 表名称 */
//@property (nonatomic, strong) NSString *className;
//
//@property (nonatomic, assign) id ACL;

@end
