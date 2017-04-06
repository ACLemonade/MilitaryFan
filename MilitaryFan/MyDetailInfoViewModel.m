//
//  MyDetailInfoViewModel.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyDetailInfoViewModel.h"

@implementation MyDetailInfoViewModel
- (NSInteger)reportContentNumber{
    return self.reportContentArray.count;
}
- (NSMutableArray<NSNumber *> *)reportSelectedStateArray{
    if (_reportSelectedStateArray == nil) {
        _reportSelectedStateArray = [NSMutableArray arrayWithArray:@[@NO, @NO, @NO, @NO]];
    }
    return _reportSelectedStateArray;
}
- (NSMutableArray *)reportContentArray{
    if (_reportContentArray == nil) {
        _reportContentArray = [NSMutableArray arrayWithArray:@[@"违法", @"叛国", @"有侮辱性词语", @""]];
    }
    return _reportContentArray;
}
- (BOOL)reportSelectedStateForRow:(NSInteger)row{
    return [[self.reportSelectedStateArray objectAtIndex:row] boolValue];
}
- (NSString *)reportContentForRow:(NSInteger)row{
    return [self.reportContentArray objectAtIndex:row];
}
@end
