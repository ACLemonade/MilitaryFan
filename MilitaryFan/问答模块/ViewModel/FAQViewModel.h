//
//  FAQViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"

@interface FAQViewModel : NSObject
/** 问题数量 */
@property (nonatomic, assign) NSInteger questionNumber;

@property (nonatomic, strong) NSMutableArray<QuestionModel *> *dataList;

- (QuestionModel *)modelForRow:(NSInteger)row;
/** 问题Id */
- (NSString *)objectIdForRow:(NSInteger)row;
/** 问题内容 */
- (NSString *)contentForRow:(NSInteger)row;
/** 提问者头像 */
- (NSURL *)headImageURLFor:(NSInteger)row;
/** 解决状态 */
- (NSString *)resolvedStateForRow:(NSInteger)row;
/** 回答数量 */
- (NSString *)answerNumberForRow:(NSInteger)row;
/** 提问时间 */
- (NSString *)createTimeForRow:(NSInteger)row;
/** 获取全部问题列表 */
//- (void)getAllQuestionWithCompletionHandle:(void(^)(NSError *error))completionHandle;

/** 根据detailType获取问题列表 */
- (void)getQuestionDataWithDetailType:(QuestionDetailType)detailType completionHandle:(void(^)(NSError *error))completionHandle;
//- (void)getQuestionWithDetailType:(QuestionDetailType)detailType completionHandle:(void(^)(NSError *error))completionHandle;
@end
