//
//  PageController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/20.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "PageController.h"
#import "MFInfoViewController.h"

@interface PageController ()

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
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(segueLeft)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
