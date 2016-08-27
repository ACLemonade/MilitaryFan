//
//  DetailVideoCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailVideoCell.h"
#import "VideoDetailViewController.h"

@implementation DetailVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconIV.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
