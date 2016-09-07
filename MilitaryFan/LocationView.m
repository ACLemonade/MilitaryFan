//
//  LocationView.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/7.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LocationView.h"

@implementation LocationView
- (UILabel *)locationLb{
    if (_locationLb == nil) {
        _locationLb = [[UILabel alloc] init];
        [self addSubview:_locationLb];
        [_locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        _locationLb.font = [UIFont systemFontOfSize:14];
    }
    return _locationLb;
}

@end
