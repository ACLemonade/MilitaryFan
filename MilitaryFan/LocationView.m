//
//  LocationView.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/7.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LocationView.h"

@interface LocationView ()
@property (nonatomic) UIImageView *locationIV;
@end
@implementation LocationView
- (instancetype)init{
    if (self = [super init]) {
        [self locationIV];
    }
    return self;
}
- (UILabel *)locationLb{
    if (_locationLb == nil) {
        _locationLb = [[UILabel alloc] init];
        [self addSubview:_locationLb];
        [_locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locationIV.mas_right).mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        _locationLb.font = [UIFont systemFontOfSize:14];
    }
    return _locationLb;
}

- (UIImageView *)locationIV {
	if(_locationIV == nil) {
		_locationIV = [[UIImageView alloc] init];
        [self addSubview:_locationIV];
        [_locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(22);
        }];
        [_locationIV setImage:[UIImage imageNamed:@"UMS_No_Location"]];
	}
	return _locationIV;
}

@end
