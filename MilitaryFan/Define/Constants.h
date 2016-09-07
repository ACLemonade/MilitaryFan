//
//  Constants.h
//  PDProject
//
//  Created by Lemonade on 16/8/15.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//三原色的设置
#define kRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//Documents文件夹的路径
#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
//appdelegate的实例对象
#define kAppdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//把self转化为 __weak __block的方式, 方便的在block中使用而不导致内存循环应用问题
#define WK(weakSelf) \
__block __weak __typeof(&*self)weakSelf = self;\
//SMS标识
#define kSMSAppKey @"1698cf6171690"
#define kSMSAppSecret @"b4683962a07c26fd45e35394266d52e2"
//UMeng标识
#define kUMengAppKey @"57cf5bfce0f55ac7d30007b0"
//头像图片路径
#define kHeadImagePath [kDocPath stringByAppendingPathComponent:@"/headImage.png"]
//详情页图片路径(用于分享)
#define kDetailImagePath [kDocPath stringByAppendingPathComponent:@"/detailImage.png"]

#define kDataBasePath [kDocPath stringByAppendingPathComponent:@"MilitaryFan.db"]

#define kUserPlistPath [kDocPath stringByAppendingPathComponent:@"User.plist"]

#define kDetailPlistPath [kDocPath stringByAppendingPathComponent:@"Detail.plist"]
#endif /* Constants_h */
