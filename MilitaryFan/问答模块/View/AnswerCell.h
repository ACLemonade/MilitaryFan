//
//  AnswerCell.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
/** 回答者头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
/** 回答者昵称 */
@property (weak, nonatomic) IBOutlet UILabel *answerNameLb;
/** 回答内容 */
@property (weak, nonatomic) IBOutlet UILabel *answerContentLb;
/** 回答者位置 */
@property (weak, nonatomic) IBOutlet UILabel *locationLb;

@end
