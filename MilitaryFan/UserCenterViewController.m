//
//  UserCenterViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/31.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "UserCenterViewController.h"

#define kTopViewH 350
@interface UserCenterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *topView;
@property (nonatomic) UIButton *iconBtn;
@property (nonatomic) NSArray *dataList;
@end

@implementation UserCenterViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.dataList objectAtIndex:section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
    NSArray *arr = [self.dataList objectAtIndex:indexPath.section];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    //小箭头
    cell.accessoryType = 1;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetH = -kTopViewH * 0.5 - offsetY;
    if (offsetH < 0) return;
    CGRect frame = self.topView.frame;
    frame.size.height = kTopViewH + offsetH;
    self.topView.frame = frame;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
#pragma mark - 方法 Methods
- (void)changeMyIconIV{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"换个头像吧!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍一张照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    UIAlertAction *localAction = [UIAlertAction actionWithTitle:@"从本地照片选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alertVC addAction:photoAction];
    [alertVC addAction:localAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.navigationItem.title = @"我";
    
}
#pragma mark - 懒加载 Lazy Load
- (UIImageView *)topView {
	if(_topView == nil) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kTopViewH, kScreenW, kTopViewH)];
        _topView.contentMode = UIViewContentModeScaleAspectFill;
        _topView.image = [UIImage imageNamed:@"BlackBird"];
        //打开imageView的用户交互,因为需要点击button更换头像
        _topView.userInteractionEnabled = YES;
        _iconBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_topView addSubview:_iconBtn];
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(75);
        }];
        [_iconBtn setImage:[UIImage imageNamed:@"Persn_login"] forState:UIControlStateNormal];
        [_iconBtn addTarget:self action:@selector(changeMyIconIV) forControlEvents:UIControlEventTouchUpInside];
	}
	return _topView;
}

- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.contentInset = UIEdgeInsetsMake(kTopViewH*0.5, 0, 0, 0);
        [_tableView insertSubview:self.topView atIndex:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCell"];
	}
	return _tableView;
}

- (NSArray *)dataList {
	if(_dataList == nil) {
        _dataList = @[@[@"个人资料", @"我的好友", @"修改密码"], @[@"我的点赞", @"我的收藏", @"我的评论"]];
	}
	return _dataList;
}

@end
