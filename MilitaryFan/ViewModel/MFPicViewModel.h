//
//  MFPicViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFInfoNetManager.h"
#import "NSObject+ViewModel.h"

@interface MFPicViewModel : BaseModel
/** UI部分 */
- (NSURL *)iconURLForIndex:(NSInteger)index;
- (NSString *)pictextForIndex:(NSInteger)index;
/** 数据部分 */
@property (nonatomic) NSInteger picNumber;
- (MFPicPicsModel *)modelForIndex:(NSInteger)index;
@property (nonatomic) NSArray<MFPicPicsModel *> *picList;
@property (nonatomic) NSString *aid;
- (instancetype)initWithAid:(NSString *)aid;
@property (nonatomic) NSString *pubDate;
//分享
@property (nonatomic) MFPicDataModel *picDataModel;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *link;
@end
