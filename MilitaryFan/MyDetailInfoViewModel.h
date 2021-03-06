//
//  MyDetailInfoViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDetailInfoViewModel : NSObject

@property (nonatomic, assign) NSInteger reportContentNumber;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *reportSelectedStateArray;

@property (nonatomic, strong) NSMutableArray *reportContentArray;
/** 举报内容选择状态 */
- (BOOL)reportSelectedStateForRow:(NSInteger)row;
/** 举报内容 */
- (NSString *)reportContentForRow:(NSInteger)row;
@end
