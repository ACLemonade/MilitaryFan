//
//  QuestionDetailCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "QuestionDetailCell.h"

@implementation QuestionDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headIV.layer.masksToBounds = YES;
    self.headIV.layer.cornerRadius = self.headIV.bounds.size.width/2;
    
    self.resolvedStateLb.layer.masksToBounds = YES;
    self.resolvedStateLb.layer.cornerRadius = 5;
    self.resolvedStateLb.layer.borderColor = kRGBA(150, 150, 150, 0.5).CGColor;
    self.resolvedStateLb.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
