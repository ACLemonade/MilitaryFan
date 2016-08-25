//
//  ShareCell.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "ShareCell.h"

@interface ShareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *wechatIV;
@property (weak, nonatomic) IBOutlet UIImageView *pyqIV;
@property (weak, nonatomic) IBOutlet UIImageView *qzoneIV;
@property (weak, nonatomic) IBOutlet UIImageView *weiboIV;

@end
@implementation ShareCell

- (void)setImgLayer:(UIImageView *)imageView{
    imageView.layer.cornerRadius = 3;
    imageView.layer.borderColor = kRGBA(229, 229, 229, 1.0).CGColor;
    imageView.layer.borderWidth = 1;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setImgLayer:_wechatIV];
    [self setImgLayer:_pyqIV];
    [self setImgLayer:_qzoneIV];
    [self setImgLayer:_weiboIV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
