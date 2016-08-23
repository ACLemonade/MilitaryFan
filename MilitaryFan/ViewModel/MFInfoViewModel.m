//
//  MFInfoViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFInfoViewModel.h"

@implementation MFInfoViewModel
#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"%s", __func__);
    return nil;
}
- (instancetype)initWithInfoType:(InfoType)infoType{
    if (self = [super init]) {
        self.infoType = infoType;
        self.currentPage = 1;
    }
    return self;
}
- (NSInteger)topNumber{
    return self.topList.count;
}
- (BOOL)isHasTop{
    return self.topNumber;
}
- (NSArray<MFSlideModel *> *)topList{
    if (_topList == nil) {
        _topList = [[NSArray alloc] init];
    }
    return _topList;
}
- (NSInteger)itemNumber{
    return self.itemList.count;
}
- (NSMutableArray<MFItemModel *> *)itemList{
    if (_itemList == nil) {
        _itemList = [NSMutableArray array];
    }
    return _itemList;
}
#pragma mark - 方法 Methods
- (MFSlideModel *)topModelForIndex:(NSInteger)index{
    return [self.topList objectAtIndex:index];
}
- (MFItemModel *)itemModelForRow:(NSInteger)row{
    return [self.itemList objectAtIndex:row];
}

- (NSURL *)topIconURLForIndex:(NSInteger)index{
    MFSlideModel *model = [self topModelForIndex:index];
    return [NSURL URLWithString:model.image];
}
- (NSString *)topTitleForIndex:(NSInteger)index{
    return [self topModelForIndex:index].title;
}

- (NSURL *)itemIconURLForRow:(NSInteger)row{
    MFItemModel *model = [self itemModelForRow:row];
    return [NSURL URLWithString:model.image];
}
- (NSArray<NSURL *> *)itemIconURLsForRow:(NSInteger)row{
    NSArray *imageArr = [self itemModelForRow:row].image_arr;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *image in imageArr) {
        NSURL *imgURL = [NSURL URLWithString:image];
        [arr addObject:imgURL];
    }
    return [arr copy];
}
- (NSString *)itemTitleForRow:(NSInteger)row{
    return [self itemModelForRow:row].title;
}
- (NSString *)itemPubDateForRow:(NSInteger)row{
    return [self itemModelForRow:row].pubDate;
}
- (NSString *)itemAuthorForRow:(NSInteger)row{
    return [self itemModelForRow:row].author;
}
- (NSString *)itemAidForRow:(NSInteger)row{
    return [self itemModelForRow:row].aid;
}
- (NSString *)itemCategoryForRow:(NSInteger)row{
    return [self itemModelForRow:row].category;
}
- (NSInteger)indexOfCellForRow:(NSInteger)row{
    NSString *image = [self itemModelForRow:row].image;
    NSString *category = [self itemModelForRow:row].category;
    if ([category isEqualToString:@"推荐"]) {
        if (image) {
            //推荐
            return 0;
        }else{
            //排行榜
            return 1;
        }
    }
    //制高点
    if ([category isEqualToString:@"制高点"]){
        return 2;
    }
    //大视野
    if ([category isEqualToString:@"大视野"]) {
        return 0;
    }
    //读点史
    if ([category isEqualToString:@"读点史"]) {
        return 0;
    }
    //流媒体
    if ([category isEqualToString:@"流媒体"]) {
        return 2;
    }
    //推广
    return 3;
}

- (void)getDataWithMode:(RequestType)mode completionHandle:(void (^)(NSError *))completionHandle{
    NSInteger tmpPage;
    switch (mode) {
        case RequestRefresh:
            tmpPage = 1;
            break;
        case RequestGetMore:
            tmpPage = _currentPage + 1;
        default:
            break;
    }
    [MFInfoNetManager getMFInfoWithType:self.infoType currentPage:tmpPage completionHandle:^(MFInfoModel *model, NSError *error) {
        if (!error) {
            if (!mode) {
                [self.itemList removeAllObjects];
            }
            self.topList = model.data.slide;
            [self.itemList addObjectsFromArray:model.data.item];
        }
        completionHandle(error);
        _currentPage = tmpPage + 1;
    }];
    
}
@end
