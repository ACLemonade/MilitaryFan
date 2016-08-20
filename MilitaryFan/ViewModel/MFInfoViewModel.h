//
//  MFInfoViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFInfoNetManager.h"
#import "NSObject+ViewModel.h"

@interface MFInfoViewModel : NSObject
/** UI部分 */
- (NSURL *)topIconURLForIndex:(NSInteger)index;
- (NSString *)topTitleForIndex:(NSInteger)index;

- (NSURL *)itemIconURLForRow:(NSInteger)row;
- (NSString *)itemTitleForRow:(NSInteger)row;
- (NSString *)itemPubDateForRow:(NSInteger)row;
- (NSString *)itemAuthorForRow:(NSInteger)row;

/** 数据部分 */
@property (nonatomic) NSInteger topNumber;
@property (nonatomic, getter=isHasTop) BOOL hasTop;
@property (nonatomic) NSArray<MFSlideModel *> *topList;
- (MFSlideModel *)topModelForIndex:(NSInteger)index;

@property (nonatomic) NSInteger itemNumber;
@property (nonatomic) NSMutableArray<MFItemModel *> *itemList;
- (MFItemModel *)itemModelForRow:(NSInteger)row;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) InfoType infoType;
@property (nonatomic) NSInteger maxPage;
- (instancetype)initWithInfoType:(InfoType)infoType;

@end
