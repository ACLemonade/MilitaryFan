//
//  CollectionViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/9/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CollectionModel.h"
#import "MFInfoNetManager.h"
#import "NSObject+ViewModel.h"

@interface CollectionViewModel : NSObject
/** UI部分 */
- (NSURL *)iconURLForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)pubDateForRow:(NSInteger)row;
/** 数据部分 */
- (NSString *)aidForRow:(NSInteger)row;
- (NSInteger)typeForRow:(NSInteger)row;
@property (nonatomic) CollectionModel *collectionModel;
- (CollectionDetailModel *)detailModelForRow:(NSInteger)row;
@property (nonatomic) NSMutableArray<CollectionDetailModel *> *itemList;
@property (nonatomic) NSInteger itemNumber;
- (void)collectionUpdate;
@end
