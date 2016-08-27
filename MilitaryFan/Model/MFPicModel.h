//
//  MFPicModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class MFPicDataModel,MFPicAdd_CodeModel,MFPicCommentsModel,MFPicPicsModel,MFPicRelationsModel;
@interface MFPicModel : BaseModel

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) MFPicDataModel *data;

@property (nonatomic, copy) NSString *mod;

@end
@interface MFPicDataModel : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) MFPicCommentsModel *comments;

@property (nonatomic, copy) NSString *badpost;

@property (nonatomic, strong) MFPicAdd_CodeModel *add_code;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *click;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, strong) NSArray<MFPicRelationsModel *> *relations;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *is_favor;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *goodpost;

@property (nonatomic, strong) NSArray<MFPicPicsModel *> *pics;

@property (nonatomic, strong) NSArray<NSString *> *content;

@end

@interface MFPicAdd_CodeModel : NSObject

@property (nonatomic, copy) NSString *ad_place_id;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *news_show_type;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *category;

@end

@interface MFPicCommentsModel : NSObject

@property (nonatomic, copy) NSString *count;

@end

@interface MFPicPicsModel : NSObject

@property (nonatomic, copy) NSString *picstext;

@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *url;

@end

@interface MFPicRelationsModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *image;

@end

