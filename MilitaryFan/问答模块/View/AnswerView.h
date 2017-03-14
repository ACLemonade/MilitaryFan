//
//  AnswerView.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/13.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnswerView;
@protocol AnswerViewDelegate <NSObject>
@required
- (void)answerView:(AnswerView *)answerView contentViewDidChanged:(UITextView *)contentView;

@end
@interface AnswerView : UIView
/** 回答内容 */
@property (nonatomic, strong) UITextView *contentView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendBtn;
/** AnswerView代理 */
@property (nonatomic, weak) id <AnswerViewDelegate> delegate;
@end
