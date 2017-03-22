//
//  QuestionCell.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
/** 问题内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
/** 提问者头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
/** 解决状态 */
@property (weak, nonatomic) IBOutlet UILabel *resolvedStateLb;
/** 回答条数 */
@property (weak, nonatomic) IBOutlet UILabel *answerNumberLb;
/** 积分图标 */
@property (weak, nonatomic) IBOutlet UIImageView *rewardIV;
/** 积分数 */
@property (weak, nonatomic) IBOutlet UILabel *rewardScoreLb;


/** 问题创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLb;
/** 是否为"我"提出的问题 */
@property (weak, nonatomic) IBOutlet UILabel *meLb;

@end
