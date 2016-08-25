//
//  VideoDetailHeaderCell.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLb;
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
@property (weak, nonatomic) IBOutlet UILabel *clickLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *zanLb;
@property (weak, nonatomic) IBOutlet UILabel *caiLb;

@end
