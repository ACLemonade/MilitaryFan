//
//  Factory.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

typedef NS_ENUM(NSUInteger, QuestionActionType) {
    QuestionActionTypeAsk,
    QuestionActionTypeAnswer
};
typedef NS_ENUM(NSUInteger, QuestionDetailType) {
    QuestionDetailTypeNone = 0,
    QuestionDetailTypeNormal = 10,
    QuestionDetailTypeReward = 11
};

@interface Factory : NSObject
/** 导航控制器返回(默认) */
+ (void)naviClickBackWithViewController:(UIViewController *)viewController;
//导航控制器返回
//+ (void)naviBarButtonWithViewController:(UIViewController *)viewController position:(NSString *)position image:(UIImage *)image text:(NSString *)text;
/** 非导航控制器返回 */
+ (void)nonNaviClickBackWithViewController:(UIViewController *)viewController;
//判断登录状态
@property (nonatomic, readonly, getter=isUserLogin) BOOL userLogin;
//提示框(收藏,点赞,评论)
+ (void)textHUDWithVC:(UIViewController *)vc text:(NSString *)text;
//提示框自动显示,按时隐藏
+ (void)autoShowHUDWithVC:(UIViewController *)vc withDelay:(NSTimeInterval)delay;

/*  根据文本内容,字体大小,行宽得到文本高度
 *
 *  @param  content 文本内容
 *  @param  font    字体大小
 *  @param  width   行宽
 *
 *  @return height  文本高度
 *
 */
+ (CGFloat)heightWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

/*  根据文本属性字典得到文本高度
 *
 *  @param  content                 文本内容
 *  @param  attributesDictionary    文本属性字典
 *
 *  @return height  文本高度
 *
 */
+ (CGFloat)heightWithContent:(NSString *)content attributesDictionary:(NSDictionary *)attributesDictionary;

/*  根据文本内容,字体大小,行宽得到文本属性字典
 *
 *  @param  content 文本内容
 *  @param  font    字体大小
 *  @param  width   行宽
 *
 *  @return attributesDictionary    文本属性字典
 *
 */
+ (NSDictionary *)attributesDictionaryWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

/** 将BmobObject对象转化成目标对象 */
+ (id)classConvertedFromBmobObject:(BmobObject *)bmobObject;

/*  定制提示框
 *
 *  @param  viewController      显示在哪个控制器上
 *  @param  title               提示框标题
 *  @param  message             提示框信息
 *
 *  @param  yesActionHander     "确定"按钮点击事件
 *  @param  cancelActionHander  "取消"按钮点击事件
 *
 *  @param  completionHandler   提示框显示完成事件
 *
 */
/** 定制提示框 */
+ (void)showAlertViewInViewController:(UIViewController *)viewController withTitle:(nullable NSString *)title message:(nullable NSString *)message yesActionHander:(void(^ __nullable)(UIAlertAction *yesAction))yesActionHander cancelActionHander:(void(^ __nullable)(UIAlertAction *cancelAction))cancelActionHander completionHandler:(void(^ __nullable)(void))completionHandler;
/** 指定时间距当前时间的时间间隔字符串,为评论等多处时间显示而个性化定制 */
+ (NSString *)timeIntervalStringSinceCurrentDate:(NSDate *)date;







@end
