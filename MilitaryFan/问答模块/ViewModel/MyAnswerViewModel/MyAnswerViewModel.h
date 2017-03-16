//
//  MyAnswerListViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerModel.h"

@interface MyAnswerViewModel : NSObject
/** 我的回答个数 */
@property (nonatomic, assign) NSInteger myAnswerNumber;
/** 回答者头像 */
- (NSURL *)answerHeadImageURLForSection:(NSInteger)section;
/** 回答者昵称 */
- (NSString *)answerNameForForSection:(NSInteger)section;
/** 回答内容 */
- (NSString *)answerContentForForSection:(NSInteger)section;
/** 回答时间 */
- (NSString *)answerTimeForForSection:(NSInteger)section;
/** 问题Id */
- (NSString *)askIdForSection:(NSInteger)section;

- (AnswerModel *)modelForForSection:(NSInteger)section;

@property (nonatomic, strong) NSMutableArray<AnswerModel *> *myAnswerList;
/** 根据回答者昵称得到回答列表 */
- (void)getMyAnswerWithAnswerName:(NSString *)answerName completionHandle:(void(^)(NSError *error))completionHandle;
@end
