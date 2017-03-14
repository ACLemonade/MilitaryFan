//
//  AllCommentsCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsCell.h"

@implementation AllCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconIV.layer.masksToBounds = YES;
    self.iconIV.layer.cornerRadius = self.iconIV.bounds.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
