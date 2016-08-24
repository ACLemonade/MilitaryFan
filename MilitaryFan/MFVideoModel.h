//
//  MFVideoModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class MFVideoDataModel,MFVideoTitleModel,MFVideoItemModel;
@interface MFVideoModel : BaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) MFVideoDataModel *data;

@property (nonatomic, copy) NSString *mod;

@end
@interface MFVideoDataModel : NSObject

@property (nonatomic, strong) MFVideoTitleModel *title;

@property (nonatomic, strong) NSArray<MFVideoItemModel *> *item;

@property (nonatomic, assign) NSInteger is_recom;

@property (nonatomic, assign) NSInteger maxpage;

@end

@interface MFVideoTitleModel : NSObject

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *desc;

@end

@interface MFVideoItemModel : NSObject

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, assign) NSInteger news_show_type;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *digg;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, copy) NSString *pl;

@end

