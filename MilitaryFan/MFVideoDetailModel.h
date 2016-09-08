//
//  MFVideoDetailModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class MFVideoDetailDataModel,MFVideoDetailAdd_CodeModel,MFVideoDetailCommentsModel,MFVideoDetailListModel;
@interface MFVideoDetailModel : BaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) MFVideoDetailDataModel *data;

@property (nonatomic, copy) NSString *mod;

@end
@interface MFVideoDetailDataModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *videoPlay;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) MFVideoDetailCommentsModel *comments;

@property (nonatomic, copy) NSString *badpost;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *click;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *video_photo;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, strong) MFVideoDetailAdd_CodeModel *add_code;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *is_favor;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *goodpost;

@property (nonatomic, strong) NSArray *relations;

@property (nonatomic, copy) NSString *video_html;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) NSArray<NSString *> *content;

@end

@interface MFVideoDetailAdd_CodeModel : BaseModel

@property (nonatomic, copy) NSString *ad_place_id;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *news_show_type;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *category;

@end

@interface MFVideoDetailCommentsModel : BaseModel

@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSArray<MFVideoDetailListModel *> *list;

@end

@interface MFVideoDetailListModel : BaseModel

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

