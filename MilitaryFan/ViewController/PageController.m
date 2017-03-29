//
//  PageController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "PageController.h"
#import "MFInfoViewController.h"
#import "UserCenterViewController.h"

@interface PageController ()
@property (nonatomic, strong) UIButton *headImageBtn;
@end

@implementation PageController
#pragma mark - 协议方法 WMPageController Delegate/DataSource
//有多少个item
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}
//每个item什么样子
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    MFInfoViewController *vc = [MFInfoViewController new];
    vc.infoType = index;
    return vc;
}
//每个item的题目
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return [self.titles objectAtIndex:index];
}
#pragma mark - 方法 Methods
- (void)segueLeft{
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.headImageBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:kHeadImagePath]] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.headImageBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 懒加载 Lazy Load
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //是否显示在导航栏上
        self.showOnNavigationBar = NO;
        //菜单高度
        self.menuHeight = 40;
        //菜单宽度
        self.menuItemWidth = 60;
        //菜单颜色
        self.menuBGColor = [UIColor clearColor];
        //菜单风格
        self.menuViewStyle = WMMenuViewStyleLine;
    }
    return self;
}
- (NSArray<NSString *> *)titles{
    return @[@"推荐", @"排行榜", @"制高点", @"图片控", @"大视野", @"读点史"];
}
#pragma mark - 懒加载 LazyLoad
- (UIButton *)headImageBtn {
	if(_headImageBtn == nil) {
        _headImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _headImageBtn.bounds = CGRectMake(0, 0, 22, 22);
//        [_headImageBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:kHeadImagePath]] forState:UIControlStateNormal];
        [_headImageBtn setTitle:@"我" forState:UIControlStateNormal];
        [_headImageBtn addTarget:self action:@selector(segueLeft) forControlEvents:UIControlEventTouchUpInside];
	}
	return _headImageBtn;
}

@end
