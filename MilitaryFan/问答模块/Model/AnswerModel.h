//
//  AnswerModel.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/14.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface AnswerModel : BaseModel
/** 回答Id */
@property (nonatomic, strong) NSString *objectId;
/** 回答者昵称 */
@property (nonatomic, strong) NSString *answerName;
/** 回答内容 */
@property (nonatomic, strong) NSString *answerContent;
/** 问题类型 */
@property (nonatomic, assign) NSInteger Type;
/** 问题Id */
@property (nonatomic, strong) NSString *askId;
/** 创建时间 */
@property (nonatomic, strong) NSString *createdAt;
/** 更新时间 */
@property (nonatomic, strong) NSString *updatedAt;
@end
