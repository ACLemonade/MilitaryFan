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
@property (nonatomic) NSMutableArray<AllCommentsDetailModel *> *commentList;
- (void)dbUpdate;
@end
@interface AllCommentsDetailModel : BaseModel
//用户名
@property (nonatomic) NSString *userName;
//评论内容
@property (nonatomic) NSString *comment;
//评论时间
@property (nonatomic) NSString *createDate;
//评论地点
@property (nonatomic) NSString *location;
@end