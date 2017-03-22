//
//  AnswerCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headIV.layer.masksToBounds = YES;
    self.headIV.layer.cornerRadius = self.headIV.bounds.size.width/2;
    
    self.adoptBtn.layer.masksToBounds = YES;
    self.adoptBtn.layer.cornerRadius = 8;
    
    self.tipOffBtn.layer.masksToBounds = YES;
    self.tipOffBtn.layer.cornerRadius = 8;
    self.tipOffBtn.layer.borderColor = kRGBA(150, 150, 150, 1.0).CGColor;
    self.tipOffBtn.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
