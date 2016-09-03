//
//  CollectionModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "BaseModel.h"

@class CollectionDetailModel;
@interface CollectionModel : BaseModel
@property (nonatomic) NSInteger collectionNumber;
@property (nonatomic) NSMutableArray<CollectionDetailModel *> *collectionList;
- (void)dbUpdate;
@end
@interface CollectionDetailModel : BaseModel
@property (nonatomic) NSString *aid;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *pubDate;

@end