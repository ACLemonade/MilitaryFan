//
//  ReportViewController.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/4/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
/** 被举报的评论/回复Id */
@property (nonatomic, strong) NSString *reportedId;
/** 被举报人昵称 */
@property (nonatomic, strong) NSString *reportedName;
@end
