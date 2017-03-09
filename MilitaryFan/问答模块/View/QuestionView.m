//
//  QuestionView.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/9.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "QuestionView.h"

@interface QuestionView ()
/** "问"图片 */
@property (nonatomic, strong) UIImageView *constAskIV;
/** "提问于"字样 */
@property (nonatomic, strong) UILabel *constAskLb;
@end

@implementation QuestionView
- (instancetype)init{
    if (self = [super init]) {
        ;
    }
    return self;
}
#pragma mark - 懒加载 LazyLoad
- (UIImageView *)headIV{
    if (_headIV == nil) {
        _headIV = [[UIImageView alloc] init];
        [self addSubview:_headIV];
        [_headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(15);
            make.size.equalTo(20);
        }];
        _headIV.backgroundColor = [UIColor lightGrayColor];
        _headIV.layer.masksToBounds = YES;
        _headIV.layer.cornerRadius = _headIV.bounds.size.width;
    }
    return _headIV;
}
- (UILabel *)askNameLb{
    if (_askNameLb == nil) {
        _askNameLb = [[UILabel alloc] init];
    }
    return _askNameLb;
}
- (UIImageView *)constAskIV{
    if (_constAskIV == nil) {
        _constAskIV = [[UIImageView alloc] init];
    }
    return _constAskIV;
}
- (UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [[UILabel alloc] init];
    }
    return _contentLb;
}
- (UILabel *)constAskLb{
    if (_constAskLb == nil) {
        _constAskLb = [[UILabel alloc] init];
    }
    return _constAskLb;
}
- (UILabel *)createTimeLb{
    if (_createTimeLb == nil) {
        _createTimeLb = [[UILabel alloc] init];
    }
    return _createTimeLb;
}
@end
