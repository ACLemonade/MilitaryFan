//
//  MFDetailViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFInfoNetManager.h"
#import "NSObject+ViewModel.h"

@interface MFDetailViewModel : NSObject
/** UI部分 */
/** 头部 */
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *pubDate;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *click;
/** 内容 */
//图片数组
@property (nonatomic) NSArray *pics;
//文章数组
@property (nonatomic) NSArray<NSString *> *content;

@property (nonatomic) NSString *image;

/** 数据部分 */
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *aid;
- (instancetype)initWithAid:(NSString *)aid;
@property (nonatomic) MFDetailDataModel *model;
@end
