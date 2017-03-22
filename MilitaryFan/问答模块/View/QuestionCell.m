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
    
    _meLb.layer.masksToBounds = YES;
    _meLb.layer.cornerRadius = _meLb.frame.size.width/2;
    _meLb.layer.borderColor = kRGBA(100, 100, 100, 1.0).CGColor;
    _meLb.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
