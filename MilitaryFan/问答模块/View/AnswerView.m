//
//  AnswerView.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/13.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerView.h"

@interface AnswerView () <UITextViewDelegate>

@end
@implementation AnswerView
- (void)textViewDidChange:(UITextView *)textView{
//    NSLog(@"contentSize: %@", NSStringFromCGSize(textView.contentSize));
    if ([_delegate respondsToSelector:@selector(answerView:contentViewDidChanged:)]) {
        [_delegate performSelector:@selector(answerView:contentViewDidChanged:) withObject:self withObject:self.contentView];
    }
    CGSize contentSize = textView.contentSize;
    CGRect frame = textView.frame;
    frame.size = contentSize;
    textView.frame = frame;
    
//    [self setNeedsDisplay];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self contentView];
    }
    return self;
}
- (UITextView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(5);
            make.bottom.equalTo(-5);
            make.right.equalTo(self.sendBtn.mas_left).equalTo(-5);
        }];
        _contentView.font = [UIFont systemFontOfSize:16];
//        _contentView.backgroundColor = kRGBA(239, 239, 244, 1.0);
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.borderColor = kRGBA(200, 200, 200, 1.0).CGColor;
        _contentView.layer.borderWidth = 1;
//        _contentView.layoutManager.allowsNonContiguousLayout = NO;
        _contentView.delegate = self;
        
    }
    return _contentView;
}
- (UIButton *)sendBtn{
    if (_sendBtn == nil) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-5);
            make.width.equalTo(40);
            make.height.equalTo(36);
        }];
        UIImage *image = [UIImage imageNamed:@"task_btn_share"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_sendBtn setImage:image forState:UIControlStateNormal];
        
//        _sendBtn.backgroundColor = [UIColor grayColor];
    }
    return _sendBtn;
    
}

@end
