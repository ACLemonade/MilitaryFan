//
//  DetailLikeCell.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailLikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likeLb;
@property (weak, nonatomic) IBOutlet UILabel *unlikeLb;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *unlikeBtn;

@end
