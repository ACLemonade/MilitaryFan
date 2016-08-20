//
//  BigPicCell.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLb;

@end
