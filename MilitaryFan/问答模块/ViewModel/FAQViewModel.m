//
//  FAQViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "FAQViewModel.h"
#import <objc/runtime.h>

@implementation FAQViewModel
- (NSInteger)latestQuestionNumber{
    return self.dataList.count;
}
- (QuestionModel *)modelForRow:(NSInteger)row{
    return [self.dataList objectAtIndex:row];
}
- (NSString *)contentForRow:(NSInteger)row{
    return [self modelForRow:row].question;
}
- (NSURL *)headImageURLFor:(NSInteger)row{
    return [NSURL URLWithString:[self modelForRow:row].headImageURL];
}
- (NSString *)resolvedStateForRow:(NSInteger)row{
    if ([self modelForRow:row].resolvedState) {
        return @"已解决";
    } else {
        return @"待解决";
    }
}
- (NSString *)answerNumberForRow:(NSInteger)row{
    return [@([self modelForRow:row].answerNumber) stringValue];
}
- (NSString *)createTimeForRow:(NSInteger)row{
    return [self modelForRow:row].createdAt;
}
- (void)getAllQuestionWithCompletionHandle:(void (^)(NSError *))completionHandle{
    [self.dataList removeAllObjects];
    BmobQuery *questionQuery = [BmobQuery queryWithClassName:@"Question"];
    questionQuery.limit = 20;
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
//            NSLog(@"array: %@", array);
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
                [self.dataList addObject:model];
//                NSLog(@"model: %@", model);
            }
            completionHandle(nil);
        }else {
            completionHandle(error);
        }
    }];
}
- (NSMutableArray<QuestionModel *> *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
