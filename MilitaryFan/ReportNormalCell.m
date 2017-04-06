//
//  ReportNormalCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReportNormalCell.h"

@implementation ReportNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.selectBtn addTarget:self action:@selector(selectSender:) forControlEvents:UIControlEventTouchUpInside];
}
//- (void)selectSender:(UIButton *)sender{
//    sender.selected = !sender.selected;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
