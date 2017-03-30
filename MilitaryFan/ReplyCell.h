//
//  ReplyCell.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/29.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyCell : UITableViewCell
/** 回复者昵称 */
@property (weak, nonatomic) IBOutlet UILabel *replyNameLb;
/** 回复时间 */
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLb;
/** 回复内容 */
@property (weak, nonatomic) IBOutlet UILabel *replyContentLb;

@end
