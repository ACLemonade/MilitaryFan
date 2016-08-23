//
//  MFDetailViewModel.h
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFInfoNetManager.h"
#import "NSObject+ViewModel.h"

@interface MFDetailViewModel : NSObject
@property (nonatomic) NSString *aid;
@property (nonatomic) NSInteger detailType;
@property (nonatomic) NSURL *linkURL;
- (instancetype)initWithAid:(NSString *)aid detailType:(NSInteger)detailType;
@property (nonatomic) MFDetailDataModel *model;
@end
