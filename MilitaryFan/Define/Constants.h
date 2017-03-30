//
//  Constants.h
//  PDProject
//
//  Created by Lemonade on 16/8/15.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - 基础设置
//-------------------基础设置-------------------------
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//三原色的设置
#define kRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define TABLEVIEW_BACKGROUNDCOLOR kRGBA(239, 239, 244, 1.0)
//状态栏导航栏的高度
#define STATUSBAR_AND_NAVIGATIONBAR_HEIGHT (20 + 44)
//菜单栏高度
#define TABBAR_HEIGHT 49
//获取简洁时间 -- yyyy-mm-dd
#define SUB_TIME(fullTime) \
[fullTime isEqualToString:@""] ? @"" : [fullTime substringToIndex:10] \
//Masonry mas_equalTo()简写宏
#define MAS_SHORTHAND_GLOBALS
//当前登录用户名
#define kUserName [[NSDictionary dictionaryWithContentsOfFile:kUserPlistPath] objectForKey:@"userName"]
//appdelegate的实例对象
#define kAppdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
//把self转化为 __weak __block的方式, 方便的在block中使用而不导致内存循环应用问题
#define WK(weakSelf) \
__block __weak __typeof(&*self)weakSelf = self;\
//大图默认图片
#define kDefaultBigImage [UIImage imageNamed:@"default-1"]
//头像默认图片
#define kDefaultHeadImage [UIImage imageNamed:@"Persn_login"]
//归解档
#define kLemonadeArchive \
- (void)encodeWithCoder:(NSCoder *)aCoder{\
unsigned int outCount = 0;\
Ivar *varList = class_copyIvarList(self.class, &outCount);\
for (int i = 0; i<outCount; i++) {\
Ivar tmpIvar = varList[i];\
const char *name = ivar_getName(tmpIvar);\
NSString *propertyName = [NSString stringWithUTF8String:name];\
id obj = [self valueForKey:propertyName];\
[aCoder encodeObject:obj forKey:propertyName];\
}\
free(varList);\
}\
- (instancetype)initWithCoder:(NSCoder *)aDecoder{\
if (self = [super init]) {\
unsigned int outCount = 0;\
Ivar *varList = class_copyIvarList(self.class, &outCount);\
for (int i = 0; i<outCount; i++) {\
Ivar tmpIvar = varList[i];\
const char *name = ivar_getName(tmpIvar);\
NSString *propertyName = [NSString stringWithUTF8String:name];\
id obj = [aDecoder decodeObjectForKey:propertyName];\
[self setValue:obj forKey:propertyName];\
}\
free(varList);\
}\
return self;\
}\
//-------------------基础设置-------------------------

#pragma mark - 第三方API标识
//-------------------第三方API标识-------------------------

//SMS标识
#define kSMSAppKey @"1698cf6171690"
#define kSMSAppSecret @"b4683962a07c26fd45e35394266d52e2"
//UMeng标识
#define kUMengAppKey @"57cf5bfce0f55ac7d30007b0"

//-------------------第三方API标识-------------------------


#pragma mark - 打印日志
//-------------------打印日志-------------------------

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif
//-------------------打印日志-------------------------


#pragma mark - 文件路径
//-------------------文件路径-------------------------
//Documents文件夹的路径
#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
//头像图片路径
#define kHeadImagePath [kUserDirectoryPath stringByAppendingPathComponent:@"/headImage.png"]
//详情页图片路径(用于分享)
#define kDetailImagePath [kDocPath stringByAppendingPathComponent:@"/detailImage.png"]
//本地数据库路径
#define kDataBasePath [kDocPath stringByAppendingPathComponent:@"MilitaryFan.db"]
//当前用户基本数据路径
#define kUserPlistPath [kDocPath stringByAppendingPathComponent:@"User.plist"]
//详情页临时数据路径
#define kDetailPlistPath [kDocPath stringByAppendingPathComponent:@"Detail.plist"]
//每个用户独有的文件夹路径
#define kUserDirectoryPath [kDocPath stringByAppendingPathComponent:[[NSDictionary dictionaryWithContentsOfFile:kUserPlistPath] objectForKey:@"userName"]]
//每个用户独有的plist文件(资料)
#define kMePlistPath [kUserDirectoryPath stringByAppendingPathComponent:@"me.plist"]
//缓存路径
#define kInfoCachePath [kDocPath stringByAppendingPathComponent:@"InfoCache"]
#define kDetailCachePath [kDocPath stringByAppendingPathComponent:@"DetailCache"]
//-------------------文件路径-------------------------



#endif /* Constants_h */
