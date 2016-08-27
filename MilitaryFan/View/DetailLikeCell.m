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
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *unlikeBtn;

@end

@implementation DetailLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置 点赞/踩 按钮 的风格--圆角带边框
    _likeView.layer.cornerRadius = 3;
    _likeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _likeView.layer.borderWidth = 1;
    
    _unlikeView.layer.cornerRadius = 3;
    _unlikeView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    _unlikeView.layer.borderWidth = 1;
    
    //打开 点赞/踩 按钮 用户交互
    [_likeBtn addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
    [_unlikeBtn addTarget:self action:@selector(clickUnlike) forControlEvents:UIControlEventTouchUpInside];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 方法 Methods
- (void)clickLike{
    NSLog(@"点赞了");
}
- (void)clickUnlike{
    NSLog(@"踩了");
}

@end
