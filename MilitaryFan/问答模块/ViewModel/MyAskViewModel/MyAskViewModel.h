//
//  MyAskViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"

@interface MyAskViewModel : NSObject
/** 问题数量 */
@property (nonatomic, assign) NSInteger myQuestionNumber;
/** 问题Id */
- (NSString *)objectIdForSection:(NSInteger)section;
/** 问题内容 */
- (NSString *)contentForSection:(NSInteger)section;
/** 提问者头像 */
- (NSURL *)headImageURLForSection:(NSInteger)section;
/** 解决状态 */
- (NSString *)resolvedStateForSection:(NSInteger)section;
/** 回答数量 */
- (NSString *)answerNumberForSection:(NSInteger)section;
/** 提问时间 */
- (NSString *)createTimeForSection:(NSInteger)section;

- (QuestionModel *)modelForSection:(NSInteger)section;

@property (nonatomic, strong) NSMutableArray<QuestionModel *> *myQustionList;
/** 根据提问者昵称得到问题列表 */
- (void)getMyQuestionWithAskName:(NSString *)askName completionHandle:(void(^)(NSError *error))completionHandle;
@end
