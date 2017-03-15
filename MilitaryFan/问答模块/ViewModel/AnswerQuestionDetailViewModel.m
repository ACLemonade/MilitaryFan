//
//  AnswerQuestionDetailViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/14.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerQuestionDetailViewModel.h"

@interface AnswerQuestionDetailViewModel ()
/** 获得回答列表(不含头像) */
- (void)getAllAnswerWithoutHeadImageWithAskId:(NSString *)askId completionHandle:(void(^)(NSArray *userNameArray, NSError *error))completionHandle;
@end

@interface AnswerQuestionDetailViewModel ()
@property (nonatomic, strong) NSMutableArray *headImageList;
@end
@implementation AnswerQuestionDetailViewModel
#pragma mark - 问题数据项
- (NSURL *)headImageURL{
    return [NSURL URLWithString:self.questionModel.headImageURL];
}
- (NSString *)askName{
    return self.questionModel.askName;
}
- (NSInteger)questionType{
    return self.questionModel.Type;
}
- (NSString *)questionContent{
    return self.questionModel.question;
}
- (NSString *)createTime{
    return self.questionModel.createdAt;
}
- (QuestionModel *)questionModel{
    if (_questionModel == nil) {
        _questionModel = [[QuestionModel alloc] init];
    }
    return _questionModel;
}
- (void)getQuestionDetailWithObjectId:(NSString *)objectId completionHandle:(void (^)(NSError *))completionHandle{
    BmobQuery *questionQuery = [BmobQuery queryWithClassName:@"Question"];
    [questionQuery getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
        if (!error) {
            NSLog(@"object: %@", object);
            //属性个数
            unsigned int count;
            //临时数据字典
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            //获取类的属性列表
            Ivar *ivars = class_copyIvarList([QuestionModel class], &count);
            for (int i = 0; i < count; i++) {
                Ivar ivar = ivars[i];
                //获取变量名称
                const char *propertyName = ivar_getName(ivar);
                NSString *key = [NSString stringWithUTF8String:propertyName];
                //将实例变量切割成键值
                key = [key substringFromIndex:1];
                //                    NSLog(@"%@", key);
                if ([object objectForKey:key]) {
                    [dataDic setObject:[object objectForKey:key] forKey:key];
                }
            }
            [self.questionModel setValuesForKeysWithDictionary:[dataDic copy]];
            BmobQuery *userQuery = [BmobQuery queryWithClassName:@"UserInfo"];
            userQuery.limit = 1;
            [userQuery whereKey:@"userName" equalTo:self.questionModel.askName];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    BmobObject *userObj = array.firstObject;
                    self.questionModel.headImageURL = [userObj objectForKey:@"headImageURL"];
                    completionHandle(nil);
                } else {
                    completionHandle(error);
                }
            }];
        } else {
            completionHandle(error);
        }
    }];
}
#pragma mark - 回答数据项
- (NSInteger)allAnswerNumber{
    return self.answerList.count;
}
- (NSURL *)answerHeadImageURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].headImageURL];
}
- (NSString *)answerNameForRow:(NSInteger)row{
    return [self modelForRow:row].answerName;
}
- (NSString *)answerContentForRow:(NSInteger)row{
    return [self modelForRow:row].answerContent;
}
- (NSString *)answerTimeForRow:(NSInteger)row{
    return [self modelForRow:row].createdAt;
}
- (AnswerModel *)modelForRow:(NSInteger)row{
    return [self.answerList objectAtIndex:row];
}
- (NSMutableArray<AnswerModel *> *)answerList{
    if (_answerList == nil) {
        _answerList = [NSMutableArray array];
    }
    return _answerList;
}
- (NSMutableArray *)headImageList{
    if (_headImageList == nil) {
        _headImageList = [NSMutableArray array];
    }
    return _headImageList;
}
- (void)getAllAnswerWithoutHeadImageWithAskId:(NSString *)askId completionHandle:(void (^)(NSArray *, NSError *))completionHandle{
    [self.answerList removeAllObjects];
    BmobQuery *answerQuery = [BmobQuery queryWithClassName:@"Answer"];
    [answerQuery whereKey:@"askId" equalTo:askId];
    [answerQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                AnswerModel *model = [[AnswerModel alloc] init];
                model.answerName = [obj objectForKey:@"answerName"];
                model.answerContent = [obj objectForKey:@"content"];
                model.createdAt = [obj objectForKey:@"createdAt"];
                [arr addObject:model.answerName];
                [self.answerList addObject:model];
            }
            completionHandle(arr, nil);
        } else {
            NSLog(@"error: %@", error);
            completionHandle(nil, error);
        }
    }];
}
- (void)getAllAnswerWithAskId:(NSString *)askId completionHandle:(void (^)(NSError *))completionHandle{
    [self getAllAnswerWithoutHeadImageWithAskId:askId completionHandle:^(NSArray *userNameArray, NSError *error) {
        if (!error) {
            for (int i = 0; i < userNameArray.count; i++) {
                NSString *userName = [userNameArray objectAtIndex:i];
                AnswerModel *model = [self.answerList objectAtIndex:i];
                BmobQuery *userQuery = [BmobQuery queryWithClassName:@"UserInfo"];
                userQuery.limit = 1;
                [userQuery whereKey:@"userName" equalTo:userName];
                [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    NSLog(@"array: %@", array);
                    BmobObject *userObj = array.firstObject;
                    model.headImageURL = [userObj objectForKey:@"headImageURL"];
                    completionHandle(nil);
                }];
            }
        } else {
            NSLog(@"error: %@", error);
            completionHandle(error);
        }
    }];
}
@end
