//
//  MFVideoDetailViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ViewModel.h"
#import "MFVideoNetManager.h"
#import "MFVideoDetailModel.h"

@interface MFVideoDetailViewModel : BaseModel
/** UI部分 */
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *pubDate;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *click;
@property (nonatomic) NSURL *iconIV;
/** 数据部分 */
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *desc;
@property (nonatomic) MFVideoDetailDataModel *model;
@property (nonatomic) NSString *aid;
- (instancetype)initWithAid:(NSString *)aid;
//视频播放链接
@property (nonatomic) NSURL *videoPlay;
@property (nonatomic) NSString *link;
@end
