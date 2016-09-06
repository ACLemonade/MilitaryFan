//
//  FunctionView.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/2.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "FunctionView.h"
@implementation FunctionView
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    if (self = [super init]) {
        [self shareBtn];
    }
    return self;
}
- (UIButton *)myCommentBtn{
    if (_myCommentBtn == nil) {
        _myCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_myCommentBtn];
        [_myCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        [_myCommentBtn setTitle:@"说点什么吧" forState:UIControlStateNormal];
        _myCommentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_myCommentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _myCommentBtn.backgroundColor = [UIColor whiteColor];
        _myCommentBtn.layer.cornerRadius = 3;
    }
    return _myCommentBtn;
}
- (UIButton *)allCommentBtn{
    if (_allCommentBtn == nil) {
        _allCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_allCommentBtn];
        [_allCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.myCommentBtn.mas_right).mas_equalTo(8);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(24);
        }];
        [_allCommentBtn setImage:[UIImage imageNamed:@"my_comment"] forState:UIControlStateNormal];
    }
    return _allCommentBtn;
}
- (UIButton *)collectionBtn {
    if(_collectionBtn == nil) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_collectionBtn];
        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(24);
            make.left.mas_equalTo(self.allCommentBtn.mas_right).mas_equalTo(8);
            make.centerY.mas_equalTo(0);
        }];
        [_collectionBtn setImage:[UIImage imageNamed:@"zhengwen_toolbar_fav"] forState:UIControlStateNormal];
        
    }
    return _collectionBtn;
}

- (UIButton *)shareBtn {
    if(_shareBtn == nil) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(24);
            make.left.mas_equalTo(self.collectionBtn.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.centerY.mas_equalTo(0);
        }];
        [_shareBtn setImage:[UIImage imageNamed:@"nav_img_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}
@end
