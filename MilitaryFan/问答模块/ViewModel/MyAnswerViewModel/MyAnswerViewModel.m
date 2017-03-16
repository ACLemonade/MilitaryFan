//
//  MyAnswerListViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyAnswerViewModel.h"

@interface MyAnswerViewModel ()
/** 根据回答者昵称获得回答列表(不含头像) */
- (void)getMyAnswerWithoutHeadImageWithAnswerName:(NSString *)answerName completionHandle:(void(^)(NSArray *userNameArray, NSError *error))completionHandle;
@end
@implementation MyAnswerViewModel
- (NSInteger)myAnswerNumber{
    return self.myAnswerList.count;
}
- (NSURL *)answerHeadImageURLForSection:(NSInteger)section{
    return [NSURL URLWithString:[self modelForForSection:section].headImageURL];
}
- (NSString *)answerNameForForSection:(NSInteger)section{
    return [self modelForForSection:section].answerName;
}
- (NSString *)answerContentForForSection:(NSInteger)section{
    return [self modelForForSection:section].answerContent;
}
- (NSString *)answerTimeForForSection:(NSInteger)section{
    return [self modelForForSection:section].createdAt;
}
- (NSString *)askIdForSection:(NSInteger)section{
    return [self modelForForSection:section].askId;
}
- (AnswerModel *)modelForForSection:(NSInteger)section{
    return [self.myAnswerList objectAtIndex:section];
}
- (NSMutableArray<AnswerModel *> *)myAnswerList{
    if (_myAnswerList == nil) {
        _myAnswerList = [NSMutableArray array];
    }
    return _myAnswerList;
}
- (void)getMyAnswerWithoutHeadImageWithAnswerName:(NSString *)answerName completionHandle:(void (^)(NSArray *, NSError *))completionHandle{
    [self.myAnswerList removeAllObjects];
    BmobQuery *myAnswerQuery = [BmobQuery queryWithClassName:@"Answer"];
    [myAnswerQuery whereKey:@"answerName" equalTo:answerName];
    [myAnswerQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            NSMutableArray *arr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                AnswerModel *model = [[AnswerModel alloc] init];
                model.answerName = [obj objectForKey:@"answerName"];
                model.answerContent = [obj objectForKey:@"content"];
                model.createdAt = [obj objectForKey:@"createdAt"];
                model.askId = [obj objectForKey:@"askId"];
                [arr addObject:model.answerName];
                [self.myAnswerList addObject:model];
            }
            completionHandle(arr, nil);
        } else {
            NSLog(@"error: %@", error);
            completionHandle(nil, error);
        }
    }];
}
- (void)getMyAnswerWithAnswerName:(NSString *)answerName completionHandle:(void (^)(NSError *))completionHandle{
    [self getMyAnswerWithoutHeadImageWithAnswerName:answerName completionHandle:^(NSArray *userNameArray, NSError *error) {
        if (!error) {
            for (int i = 0; i < userNameArray.count; i++) {
                NSString *userName = [userNameArray objectAtIndex:i];
                AnswerModel *model = [self.myAnswerList objectAtIndex:i];
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
            NSLog(@"error: %@", error);
            completionHandle(error);
        }
    }];
}
@end
