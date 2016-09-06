//
//  AllCommentsCell.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *commentDateLb;
@property (weak, nonatomic) IBOutlet UILabel *commentLocationLb;
@property (weak, nonatomic) IBOutlet UILabel *commentLb;

@end
