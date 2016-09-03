//
//  LeftMenuViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UserCenterViewController.h"
#import "CollectionViewController.h"
#import "UserInfoCell.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataList;
@end

@implementation LeftMenuViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.dataList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:kHeadImagePath]) {
            [[NSOperationQueue new] addOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfFile:kHeadImagePath];
                UIImage *headImage = [UIImage imageWithData:data];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.iconIV.image = headImage;
                }];
            }];
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UINavigationController *userNavi = [[UIStoryboard storyboardWithName:@"UserCenter" bundle:nil] instantiateInitialViewController];
        UserCenterViewController *userCenterVC = [userNavi.viewControllers objectAtIndex:0];
        userCenterVC.myBlock = ^(UIImage *image){
            cell.iconIV.image = image;
        };
        [self presentViewController:userNavi animated:YES completion:nil];
    }
    if (indexPath.section == 1) {
        CollectionViewController *collectionVC = [CollectionViewController new];
        UINavigationController *collectNavi = [[UINavigationController alloc] initWithRootViewController:collectionVC];
        [self presentViewController:collectNavi animated:YES completion:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 134;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}


#pragma mark - 懒加载 Lazy Load
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(390);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //去弹簧效果
        _tableView.bounces = NO;
        
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"UserInfoCell"];
        
	}
	return _tableView;
}

- (NSArray *)dataList {
	if(_dataList == nil) {
        _dataList = @[@"我的收藏", @"我的点赞", @"我的评论", @"我的消息"];
	}
	return _dataList;
}

@end
