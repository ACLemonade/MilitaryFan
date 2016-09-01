//
//  MFPicViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/27.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "MFPicViewController.h"
#import "MFPicViewModel.h"

@interface MFPicViewController () <MWPhotoBrowserDelegate>
@property (nonatomic) MFPicViewModel *picVM;

@end

@implementation MFPicViewController
//有多少张photo
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.picVM.picNumber;
}
//每张photo是什么样子
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photo = [MWPhoto photoWithURL:[self.picVM iconURLForIndex:index]];
    if (![[self.picVM pictextForIndex:index] isEqualToString:@""]) {
        photo.caption = [self.picVM pictextForIndex:index];
    }
    return photo;
}

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.picVM getDataWithMode:0 completionHandle:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            [self reloadData];
        }
    }];
}
#pragma mark - 懒加载 Lazy Load
- (MFPicViewModel *)picVM {
	if(_picVM == nil) {
        _picVM = [[MFPicViewModel alloc] initWithAid:self.aid];
	}
	return _picVM;
}
- (instancetype)init{
    if (self = [super init]) {
        //是否有操作按钮--分享 复制 etc
        self.displayActionButton = YES;
        //是否左右翻页
        self.displayNavArrows = YES;
        //是否被选中
        self.displaySelectionButtons = NO;
        //是否支持缩放
        self.zoomPhotosToFill = YES;
        //是否总是显示控制界面
        self.alwaysShowControls = NO;
        //是否支持GridView
        self.enableGrid = YES;
        //是否从GridView开始
        self.startOnGrid = NO;
        //将代理设置为自身
        self.delegate = self;
    }
    return self;
}


@end
