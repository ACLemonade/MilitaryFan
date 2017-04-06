//
//  UserCenterHeadView.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/4/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UserCenterHeadView.h"

@implementation UserCenterHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self iconBtn];
        [self naviBackBtn];
    }
    return self;
}
- (UIImageView *)backgroundIV{
    if (_backgroundIV == nil) {
        _backgroundIV = [[UIImageView alloc] init];
        [self addSubview:_backgroundIV];
        [_backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _backgroundIV.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundIV.image = [UIImage imageNamed:@"BlackBird"];
        //打开imageView的用户交互,因为需要点击button更换头像
        _backgroundIV.userInteractionEnabled = YES;

    }
    return _backgroundIV;
}
- (UIButton *)iconBtn{
    if (_iconBtn == nil) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundIV addSubview:_iconBtn];
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(0);
            make.size.equalTo(75);
        }];
        _iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        _iconBtn.imageView.layer.masksToBounds = YES;
        _iconBtn.imageView.layer.cornerRadius = 37.5;
    }
    return _iconBtn;
}
- (UIButton *)naviBackBtn{
    if (_naviBackBtn == nil) {
        _naviBackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.backgroundIV addSubview:_naviBackBtn];
        [_naviBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(22);
            make.left.equalTo(15);
            make.top.equalTo(35);
        }];
        [_naviBackBtn setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
    }
    return _naviBackBtn;
}
@end
