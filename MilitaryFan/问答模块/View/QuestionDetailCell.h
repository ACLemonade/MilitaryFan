//
//  QuestionDetailCell.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailCell : UITableViewCell
/** 提问者头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
/** 提问者昵称 */
@property (weak, nonatomic) IBOutlet UILabel *askNameLb;
/** 问题内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
/** 提问时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLb;
/** 解决状态 */
@property (weak, nonatomic) IBOutlet UILabel *resolvedStateLb;

@end
