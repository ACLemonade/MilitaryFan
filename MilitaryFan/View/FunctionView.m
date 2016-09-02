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
- (UITextField *)commentTF {
    if(_commentTF == nil) {
        _commentTF = [[UITextField alloc] init];
        _commentTF.borderStyle = UITextBorderStyleRoundedRect;
        _commentTF.placeholder = @"说点什么吧";
        _commentTF.font = [UIFont systemFontOfSize:14];
        [self addSubview:_commentTF];
        [_commentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _commentTF;
}
- (UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.commentTF.mas_right).mas_equalTo(8);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(24);
        }];
        [_commentBtn setImage:[UIImage imageNamed:@"my_comment"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}
- (UIButton *)collectionBtn {
    if(_collectionBtn == nil) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_collectionBtn];
        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(24);
            make.left.mas_equalTo(self.commentBtn.mas_right).mas_equalTo(8);
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
