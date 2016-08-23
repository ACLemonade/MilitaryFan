//
//  MFDetailModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class MFDetailDataModel,MFDetailAdd_CodeModel,MFDetailCommentsModel,MFDetailListModel;
@interface MFDetailModel : BaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) MFDetailDataModel *data;

@property (nonatomic, copy) NSString *mod;

@end
@interface MFDetailDataModel : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *video_play;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) MFDetailCommentsModel *comments;

@property (nonatomic, copy) NSString *badpost;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *click;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *video_photo;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, strong) MFDetailAdd_CodeModel *add_code;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *is_favor;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *goodpost;

@property (nonatomic, strong) NSArray *relations;

@property (nonatomic, copy) NSString *video_html;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) NSArray<NSString *> *content;

@end

@interface MFDetailAdd_CodeModel : NSObject

@property (nonatomic, copy) NSString *ad_place_id;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *news_show_type;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *category;

@end

@interface MFDetailCommentsModel : NSObject

@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSArray<MFDetailListModel *> *list;

@end

@interface MFDetailListModel : NSObject

@property (nonatomic, copy) NSString *replys;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *dtime;

@property (nonatomic, copy) NSString *face;

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, strong) NSArray *list;

@end

