//
//  AllCommentsModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class AllCommentsDetailModel;

@interface AllCommentsModel : BaseModel

- (void)dbUpdateWithCompletionHandle:(void(^)(NSArray<AllCommentsDetailModel *> * array))completionHandle;
@end
@interface AllCommentsDetailModel : BaseModel
//头像
@property (nonatomic) NSString *headImageURL;
//用户名
@property (nonatomic) NSString *userName;
//评论内容
@property (nonatomic) NSString *comment;
//评论时间
@property (nonatomic) NSString *createDate;
//评论地点
@property (nonatomic) NSString *location;
@end