//
//  MFVideoViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ViewModel.h"
#import "MFVideoNetManager.h"

@interface MFVideoViewModel : NSObject
/** UI部分 */
- (NSURL *)iconURLForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSString *)authorForRow:(NSInteger)row;
- (NSString *)pubDateForRow:(NSInteger)row;
/** 数据部分 */
@property (nonatomic) NSInteger itemNumber;
- (MFVideoItemModel *)modelForRow:(NSInteger)row;
@property (nonatomic) NSMutableArray<MFVideoItemModel *> *itemList;

@property (nonatomic) NSInteger currentPage;
@end
