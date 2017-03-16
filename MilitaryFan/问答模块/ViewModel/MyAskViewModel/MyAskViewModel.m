//
//  MyAskViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyAskViewModel.h"
#import <objc/runtime.h>

@interface MyAskViewModel ()
/** 根据提问者昵称获得问题列表(不含头像) */
- (void)getMyQuestionWithoutHeadImageWithAskName:(NSString *)askName completionHandle:(void(^)(NSArray *userNameArray, NSError *error))completionHandle;
@end
@implementation MyAskViewModel
- (NSInteger)myQuestionNumber{
    return self.myQustionList.count;
}
- (NSString *)objectIdForSection:(NSInteger)section{
    return [self modelForSection:section].objectId;
}
- (NSString *)contentForSection:(NSInteger)section{
    return [self modelForSection:section].question;
}
- (NSURL *)headImageURLForSection:(NSInteger)section{
    return [NSURL URLWithString:[self modelForSection:section].headImageURL];
}
- (NSString *)resolvedStateForSection:(NSInteger)section{
    if ([self modelForSection:section].resolvedState) {
        return @"已解决";
    } else {
        return @"未解决";
    }
}
- (NSString *)answerNumberForSection:(NSInteger)section{
    return [@([self modelForSection:section].answerNumber) stringValue];
}
- (NSString *)createTimeForSection:(NSInteger)section{
    return SUB_TIME([self modelForSection:section].createdAt);
}
- (QuestionModel *)modelForSection:(NSInteger)section{
    return [self.myQustionList objectAtIndex:section];
}
- (NSMutableArray<QuestionModel *> *)myQustionList{
    if (_myQustionList == nil) {
        _myQustionList = [NSMutableArray array];
    }
    return _myQustionList;
}
- (void)getMyQuestionWithoutHeadImageWithAskName:(NSString *)askName completionHandle:(void (^)(NSArray *, NSError *))completionHandle{
    [self.myQustionList removeAllObjects];
    BmobQuery *myQuestionQuery = [BmobQuery queryWithClassName:@"Question"];
    [myQuestionQuery whereKey:@"askName" equalTo:askName];
    //按时间倒序
    [myQuestionQuery orderByDescending:@"createdAt"];
    [myQuestionQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            //            NSLog(@"array: %@", array);
            NSMutableArray *userNameArr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                QuestionModel *model = [[QuestionModel alloc] init];
                /*
                 *  由于BmobObject实例对象obj不属于字典对象,但是获取数据却要使用objectForKey方法,十分麻烦,因此使用runtime遍历QuestionModel属性名,用其将obj对应的值取出,之后将其赋给QuestionModel实例对象model,方便之后的使用(当字段少的时候无明显差别,字段多的时候有显著差距)
                 *
                 */
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
                    if ([obj objectForKey:key]) {
                        [dataDic setObject:[obj objectForKey:key] forKey:key];
                    }
                }
                [model setValuesForKeysWithDictionary:[dataDic copy]];
                [self.myQustionList addObject:model];
                [userNameArr addObject:model.askName];
                //                NSLog(@"model: %@", model);
            }
            completionHandle([userNameArr copy], nil);
        } else {
            completionHandle(nil, error);
        }
    }];
}
- (void)getMyQuestionWithAskName:(NSString *)askName completionHandle:(void (^)(NSError *))completionHandle{
    [self getMyQuestionWithoutHeadImageWithAskName:askName completionHandle:^(NSArray *userNameArray, NSError *error) {
        if (!error) {
            for (int i = 0; i < userNameArray.count; i++) {
                NSString *userName = [userNameArray objectAtIndex:i];
                QuestionModel *model = [self.myQustionList objectAtIndex:i];
                BmobQuery *userQuery = [BmobQuery queryWithClassName:@"UserInfo"];
                userQuery.limit = 1;
                [userQuery whereKey:@"userName" equalTo:userName];
                [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    //                    NSLog(@"array: %@", array);
                    BmobObject *userObj = array.firstObject;
                    model.headImageURL = [userObj objectForKey:@"headImageURL"];
                    completionHandle(nil);
                }];
            }
        } else {
            completionHandle(error);
        }
    }];
}
@end
