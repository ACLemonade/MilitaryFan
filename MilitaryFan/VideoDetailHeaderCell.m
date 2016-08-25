//
//  VideoDetailHeaderCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "VideoDetailHeaderCell.h"

@interface VideoDetailHeaderCell()
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIView *caiView;

@end
@implementation VideoDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _zanView.layer.cornerRadius = 3;
    _zanView.layer.borderWidth = 1;
    _zanView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    
    _caiView.layer.cornerRadius = 3;
    _caiView.layer.borderWidth = 1;
    _caiView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
