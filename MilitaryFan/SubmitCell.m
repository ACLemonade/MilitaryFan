//
//  SubmitCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/4/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "SubmitCell.h"

@implementation SubmitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
