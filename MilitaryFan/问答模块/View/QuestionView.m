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
        [self createTimeLb];
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
        [self addSubview:_askNameLb];
        [_askNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIV.mas_right).equalTo(15);
            make.centerY.equalTo(self.headIV);
        }];
        _askNameLb.font = [UIFont systemFontOfSize:15];
    }
    return _askNameLb;
}
- (UIImageView *)constAskIV{
    if (_constAskIV == nil) {
        _constAskIV = [[UIImageView alloc] init];
        [self addSubview:_constAskIV];
        [_constAskIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(self.headIV);
            make.size.equalTo(20);
        }];
        _constAskIV.backgroundColor = [UIColor lightGrayColor];
    }
    return _constAskIV;
}
- (UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [[UILabel alloc] init];
        [self addSubview:_contentLb];
        [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.constAskIV);
            make.left.equalTo(15);
        }];
        _contentLb.text = @"的电话翁糊废物而获rfjwepofjpwefjweoifjzsdvcofjcsoe;fjwoejfoeijfoiejf覅uefhioawehfocjsdlkcjsldef1";
        _contentLb.font = [UIFont systemFontOfSize:20];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}
- (UILabel *)constAskLb{
    if (_constAskLb == nil) {
        _constAskLb = [[UILabel alloc] init];
        [self addSubview:_constAskLb];
        [_constAskLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLb.mas_bottom).equalTo(15);
            make.left.equalTo(self.constAskIV);
        }];
        _constAskLb.text = @"提问于";
        _constAskLb.font = [UIFont systemFontOfSize:12];
    }
    return _constAskLb;
}
- (UILabel *)createTimeLb{
    if (_createTimeLb == nil) {
        _createTimeLb = [[UILabel alloc] init];
        [self addSubview:_createTimeLb];
        [_createTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.constAskLb);
            make.left.equalTo(15);
        }];
        _createTimeLb.text = @"0000000";
        _createTimeLb.font = [UIFont systemFontOfSize:12];
    }
    return _createTimeLb;
}
@end
