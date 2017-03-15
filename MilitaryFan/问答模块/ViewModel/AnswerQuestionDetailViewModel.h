//
//  AnswerQuestionDetailViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/14.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"
#import "AnswerModel.h"

@interface AnswerQuestionDetailViewModel : NSObject
/** 提问者头像 */
@property (nonatomic, strong) NSURL *headImageURL;
/** 提问者昵称 */
@property (nonatomic, strong) NSString *askName;
/** 问题类型 */
@property (nonatomic, assign) NSInteger questionType;
/** 问题内容 */
@property (nonatomic, strong) NSString *questionContent;
/** 提问时间 */
@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) QuestionModel *questionModel;
/** 根据objectId得到问题 */
- (void)getQuestionDetailWithObjectId:(NSString *)objectId completionHandle:(void(^)(NSError *error))completionHandle;



@property (nonatomic, assign) NSInteger allAnswerNumber;
/** 回答者头像 */
- (NSURL *)answerHeadImageURLForRow:(NSInteger)row;
/** 回答者昵称 */
- (NSString *)answerNameForRow:(NSInteger)row;
/** 回答内容 */
- (NSString *)answerContentForRow:(NSInteger)row;
/** 回答时间 */
- (NSString *)answerTimeForRow:(NSInteger)row;

- (AnswerModel *)modelForRow:(NSInteger)row;

@property (nonatomic, strong) NSMutableArray<AnswerModel *> *answerList;

/** 获得回答列表(含头像) */
- (void)getAllAnswerWithAskId:(NSString *)askId completionHandle:(void(^)(NSError *error))completionHandle;
@end
