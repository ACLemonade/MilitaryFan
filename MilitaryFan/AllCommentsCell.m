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
    
    self.replyBtn.layer.masksToBounds = YES;
    self.replyBtn.layer.cornerRadius = 8;
    self.replyBtn.layer.borderColor = kRGBA(150, 150, 150, 1.0).CGColor;
    self.replyBtn.layer.borderWidth = 0.5;
    
    self.reportBtn.layer.masksToBounds = YES;
    self.reportBtn.layer.cornerRadius = 8;
    self.reportBtn.layer.borderColor = kRGBA(150, 150, 150, 1.0).CGColor;
    self.reportBtn.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
