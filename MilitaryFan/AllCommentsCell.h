//
//  AllCommentsCell.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCommentsCell : UITableViewCell
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
/** 评论者昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
/** 评论时间 */
@property (weak, nonatomic) IBOutlet UILabel *commentDateLb;
/** 评论地点 */
@property (weak, nonatomic) IBOutlet UILabel *commentLocationLb;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *commentLb;
/** 点赞按钮 */
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
/** 点赞人数 */
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLb;
/** 举报按钮 */
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
/** 查看回复按钮 */
@property (weak, nonatomic) IBOutlet UIButton *revealReplyBtn;


@end
