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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
