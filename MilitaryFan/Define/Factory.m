//
//  Factory.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "Factory.h"
#import <UIControl+BlocksKit.h>

@implementation Factory
+ (void)naviClickBackWithViewController:(UIViewController *)viewController{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn bk_addEventHandler:^(id sender) {
        [viewController.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBarBtn;
}
+ (void)nonNaviClickBackWithViewController:(UIViewController *)viewController{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn bk_addEventHandler:^(id sender) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBarBtn;
}
- (BOOL)isUserLogin{
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSNumber *loginState = [userDic objectForKey:@"loginState"];
    if (loginState.integerValue) {
        return YES;
    }else{
        return NO;
    }
}
+ (void)textHUDWithVC:(UIViewController *)vc text:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(text, @"HUD message title");
    [hud hideAnimated:YES afterDelay:1.f];
}
+ (void)autoShowHUDWithVC:(UIViewController *)vc withDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.navigationController.view animated:YES];
    [hud hideAnimated:YES afterDelay:delay];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
}
+ (CGFloat)heightWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    //折行方式
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    //对齐方式
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    //段落间距
//    paragraphStyle.lineSpacing = 10.0;
//    //判断每行最后一个单词是否被截断,数值介于0.0~1.0,越靠近1.0被截断的几率越大
//    paragraphStyle.hyphenationFactor = 1.0;
//    //首行缩进
//    paragraphStyle.firstLineHeadIndent = 100.0;
//    //段落前间距(暂时发现\n存在时生效)
//    paragraphStyle.paragraphSpacingBefore = 0.0;
//    //段落后间距(暂时发现\n存在时生效)
//    paragraphStyle.paragraphSpacing = 0.0;
//    //行间距(是默认行间距的多少倍)
//    paragraphStyle.lineHeightMultiple = 1.0;
//    paragraphStyle.headIndent = 0;
//    paragraphStyle.tailIndent = 0;
//    
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f};
    NSDictionary *dic = [[self class] attributesDictionaryWithContent:content font:font width:width];
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
+ (NSDictionary *)attributesDictionaryWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //折行方式
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //对齐方式
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //段落间距
    paragraphStyle.lineSpacing = 10.0;
    //判断每行最后一个单词是否被截断,数值介于0.0~1.0,越靠近1.0被截断的几率越大
    paragraphStyle.hyphenationFactor = 1.0;
    //首行缩进
    paragraphStyle.firstLineHeadIndent = 0.0;
    //段落前间距(暂时发现\n存在时生效)
    paragraphStyle.paragraphSpacingBefore = 0.0;
    //段落后间距(暂时发现\n存在时生效)
    paragraphStyle.paragraphSpacing = 0.0;
    //行间距(是默认行间距的多少倍)
    paragraphStyle.lineHeightMultiple = 1.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.5f};
    return dic;
}
+ (id)classConvertedFromBmobObject:(BmobObject *)bmobObject{
    return nil;
}

+ (void)showAlertViewInViewController:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message yesActionHander:(void (^)(UIAlertAction *))yesActionHander cancelActionHander:(void (^)(UIAlertAction *))cancelActionHander completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        yesActionHander(action);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelActionHander(action);
    }];
    [alertVC addAction:yesAction];
    [alertVC addAction:cancelAction];
    [viewController presentViewController:alertVC animated:YES completion:^{
        completionHandler();
    }];
}
+ (NSString *)timeIntervalStringSinceCurrentDate:(NSDate *)date{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    NSInteger difference = timeInterval;
    if (difference < 60) {
        return @"刚刚";
    } else if (difference < 60*60) {
        return [NSString stringWithFormat:@"%ld分钟前", difference / 60];
    } else if (difference < 60*60*24) {
        return [NSString stringWithFormat:@"%ld小时前", difference / (60*60)];
    } else if (difference < 60*60*24*2) {
        return @"昨天";
    } else {
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
        dataFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *replyTime = [dataFormatter stringFromDate:date];
        return replyTime;
    }
}
@end
