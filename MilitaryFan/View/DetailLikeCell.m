//
//  DetailLikeCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "DetailLikeCell.h"

@interface DetailLikeCell()
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *unlikeView;
@end

@implementation DetailLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _likeView.layer.cornerRadius = 3;
    _likeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _likeView.layer.borderWidth = 1;
    
    _unlikeView.layer.cornerRadius = 3;
    _unlikeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _unlikeView.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
