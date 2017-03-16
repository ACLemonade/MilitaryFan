//
//  RewardView.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/9.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "RewardView.h"

@interface RewardView ()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *nameLb;

@end
@implementation RewardView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self nameLb];
        [self minusBtn];
    }
    return self;
}
- (UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [[UIImageView alloc] init];
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
            make.size.equalTo(15);
        }];
        _iconIV.image = [UIImage imageNamed:@"reward"];
//        _iconIV.image = [UIImage imageNamed:@"money"];
//        _iconIV.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconIV;
}
- (UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [[UILabel alloc] init];
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(15);
            make.centerY.equalTo(0);
        }];
        _nameLb.text = @"悬赏积分";
        _nameLb.font = [UIFont systemFontOfSize:15];
    }
    return _nameLb;
}
- (UIButton *)minusBtn{
    if (_minusBtn == nil) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_minusBtn];
        [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rewardTF.mas_left).equalTo(-5);
            make.centerY.equalTo(0);
            make.size.equalTo(20);
        }];
        UIImage *image = [UIImage imageNamed:@"minus"];
        //关闭图片渲染
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_minusBtn setImage:image forState:UIControlStateNormal];
        _minusBtn.tag = 10;
        
        
    }
    return _minusBtn;
}
- (UIButton *)plusBtn{
    if (_plusBtn == nil) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_plusBtn];
        [_plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(0);
            make.size.equalTo(20);
        }];
        UIImage *image = [UIImage imageNamed:@"plus"];
        //关闭图片渲染
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_plusBtn setImage:image forState:UIControlStateNormal];
        _plusBtn.tag = 11;
        
    }
    return _plusBtn;
}
- (UITextField *)rewardTF{
    if (_rewardTF == nil) {
        _rewardTF = [[UITextField alloc] init];
        [self addSubview:_rewardTF];
        [_rewardTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.plusBtn.mas_left).equalTo(-5);
            make.centerY.equalTo(0);
            make.width.equalTo(40);
            make.height.equalTo(20);

        }];
        _rewardTF.text = @"1";
        _rewardTF.font = [UIFont systemFontOfSize:15];
        _rewardTF.textAlignment = NSTextAlignmentCenter;
        _rewardTF.keyboardType = UIKeyboardTypeNumberPad;
        
        _rewardTF.textColor = kRGBA(161, 161, 161, 1.0);
        _rewardTF.borderStyle = UITextBorderStyleNone;
        
        _rewardTF.layer.borderWidth = 0.5;
        _rewardTF.layer.borderColor = kRGBA(161, 161, 161, 1.0).CGColor;

    }
    return _rewardTF;
}
@end
