//
//  MFInfoModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class MFDataModel,MFTitleModel,MFNavModel,MFSlideModel,MFItemModel;
@interface MFInfoModel : BaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) MFDataModel *data;

@property (nonatomic, copy) NSString *mod;

@end
@interface MFDataModel : NSObject

@property (nonatomic, assign) NSInteger maxpage;

@property (nonatomic, strong) NSArray<MFNavModel *> *nav;

@property (nonatomic, strong) MFTitleModel *title;

@property (nonatomic, strong) NSArray<MFItemModel *> *item;

@property (nonatomic, strong) NSArray<MFSlideModel *> *slide;

@property (nonatomic, assign) NSInteger is_recom;

@end

@interface MFTitleModel : NSObject

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *desc;

@end

@interface MFNavModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@end

@interface MFSlideModel : NSObject

@property (nonatomic, assign) BOOL category;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *news_show_type;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *digg;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *pl;

@end

@interface MFItemModel : NSObject

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, assign) NSInteger news_show_type;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *digg;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *pl;

@property (nonatomic, copy) NSString *red_tag;

@property (nonatomic, assign) NSInteger yituwutu;

@property (nonatomic, strong) NSArray<NSString *> *image_arr;

@property (nonatomic, assign) NSInteger santu;

@property (nonatomic, assign) NSInteger img_length;

@end

