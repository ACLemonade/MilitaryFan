//
//  QuestionView.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/9.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionView : UIView
/** 提问者头像 */
@property (nonatomic, strong) UIImageView *headIV;
/** 提问者昵称 */
@property (nonatomic, strong) UILabel *askNameLb;
/** 问题内容 */
@property (nonatomic, strong) UILabel *contentLb;
/** 提问时间 */
@property (nonatomic, strong) UILabel *createTimeLb;
@end
