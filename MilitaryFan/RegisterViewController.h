//
//  RegisterViewController.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/29.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *account, NSString *password);

@interface RegisterViewController : UIViewController
@property (nonatomic, copy) MyBlock myBlock;
@end
