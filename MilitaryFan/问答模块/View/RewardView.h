//
//  RewardView.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/9.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardView : UIView
/** 减少按钮 */
@property (nonatomic, strong) UIButton *minusBtn;
/** 增加按钮 */
@property (nonatomic, strong) UIButton *plusBtn;
/** 积分数值 */
@property (nonatomic, strong) UITextField *rewardTF;
@end
