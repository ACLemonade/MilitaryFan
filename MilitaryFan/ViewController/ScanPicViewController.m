//
//  ScanPicViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/17.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "ScanPicViewController.h"
#import "iCarousel.h"
#import "MFPicViewModel.h"
#import <UIImageView+WebCache.h>

@interface ScanPicViewController () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic) iCarousel *ic;
@property (nonatomic) MFPicViewModel *picVM;
@end

@implementation ScanPicViewController
#pragma mark - 协议方法 iCarousel Delegate/DataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.picVM.picNumber;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:self.ic.frame];
        UIImageView *iv = [[UIImageView alloc] init];
        [view addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        iv.tag = 100;
    }
    UIImageView *iv = [view viewWithTag:100];
    [iv setImageWithURL:[self.picVM iconURLForIndex:index]];
    return view;
}
//返回配置
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //间距
    if (option == iCarouselOptionSpacing) {
        value *= 1;
    }
    //是否滚动
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self ic];
}
#pragma mark - 懒加载 LazyLoad
- (iCarousel *)ic {
	if(_ic == nil) {
		_ic = [[iCarousel alloc] init];
        [self.view addSubview:_ic];
        [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW*0.6);
            make.height.mas_equalTo(kScreenH*0.6);
        }];
        /*
         iCarouselTypeLinear = 0,
         iCarouselTypeRotary,
         iCarouselTypeInvertedRotary,
         iCarouselTypeCylinder,
         iCarouselTypeInvertedCylinder,
         iCarouselTypeWheel,
         iCarouselTypeInvertedWheel,
         iCarouselTypeCoverFlow,
         iCarouselTypeCoverFlow2,
         iCarouselTypeTimeMachine,
         iCarouselTypeInvertedTimeMachine,
         iCarouselTypeCustom
         */
        _ic.type = iCarouselTypeTimeMachine;
        _ic.delegate = self;
        _ic.dataSource = self;
        _ic.autoscroll = YES;
        _ic.scrollSpeed = 0.1;
	}
	return _ic;
}

- (MFPicViewModel *)picVM {
	if(_picVM == nil) {
        _picVM = [[MFPicViewModel alloc] initWithAid:self.aid];
	}
	return _picVM;
}

@end
