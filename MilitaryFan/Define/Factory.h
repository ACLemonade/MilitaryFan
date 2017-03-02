//
//  Factory.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Factory : NSObject
//导航控制器返回(默认)
+ (void)naviClickBackWithViewController:(UIViewController *)viewController;
//导航控制器返回
//+ (void)naviBarButtonWithViewController:(UIViewController *)viewController position:(NSString *)position image:(UIImage *)image text:(NSString *)text;
//非导航控制器返回
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

@end
