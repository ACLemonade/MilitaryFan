//
//  UserCenterViewController.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/31.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(UIImage *image);
@interface UserCenterViewController : UIViewController
@property (nonatomic, copy) MyBlock myBlock;
@end
