//
//  AllCommentsViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllCommentsModel.h"
@interface AllCommentsViewModel : NSObject
/** UI部分 */
- (NSString *)iconIVForRow:(NSInteger)row;
- (NSString *)userNameForRow:(NSInteger)row;
- (NSString *)userLocationForRow:(NSInteger)row;
- (NSString *)createDateForRow:(NSInteger)row;
- (NSString *)commentForRow:(NSInteger)row;
/** 数据部分 */
//评论个数
@property (nonatomic) NSInteger commentNumber;
@property (nonatomic) NSArray<AllCommentsDetailModel *> *commentList;
- (AllCommentsDetailModel *)modelForRow:(NSInteger)row;

@property (nonatomic) AllCommentsModel *allCommentsModel;
- (void)commentUpdate;

@end
