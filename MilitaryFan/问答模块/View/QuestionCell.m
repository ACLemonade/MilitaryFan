//
//  QuestionCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headIV.layer.masksToBounds = YES;
    _headIV.layer.cornerRadius = _headIV.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
