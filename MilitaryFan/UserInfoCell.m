//
//  UserInfoCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/31.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconIV.layer.masksToBounds = YES;
    _iconIV.layer.cornerRadius = _iconIV.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
