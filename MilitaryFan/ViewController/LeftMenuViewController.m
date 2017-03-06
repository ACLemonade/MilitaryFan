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
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "UserInfoCell.h"

#import "UIScrollView+Refresh.h"

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
        //从User.plist读取登录信息
        NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
        NSString *userName = [userDic objectForKey:@"userName"];
        NSNumber *loginState = [userDic objectForKey:@"loginState"];
        if ([loginState integerValue]) {
            cell.userNameLb.text = userName;
            cell.userNameLb.textColor = [UIColor blackColor];
            if ([[NSFileManager defaultManager] fileExistsAtPath:kHeadImagePath]) {
                [[NSOperationQueue new] addOperationWithBlock:^{
                    NSData *data = [NSData dataWithContentsOfFile:kHeadImagePath];
                    UIImage *headImage = [UIImage imageWithData:data];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        cell.iconIV.image = headImage;
                    }];
                }];
            }
        }else{
            cell.userNameLb.text = @"点击登录";
            cell.userNameLb.textColor = [UIColor grayColor];
            cell.userNameLb.font = [UIFont systemFontOfSize:20];
            [cell.iconIV setImage:[UIImage imageNamed:@"Persn_login"]];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalCell"];
        }
        cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
        if (indexPath.row>0) {
            cell.textLabel.textColor = [UIColor grayColor];
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //判断登录状态
        Factory *factory = [[Factory alloc] init];
        //已经登录,则跳转至用户中心
        if (factory.isUserLogin) {
            UserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UINavigationController *userNavi = [[UIStoryboard storyboardWithName:@"UserCenter" bundle:nil] instantiateInitialViewController];
            UserCenterViewController *userCenterVC = [userNavi.viewControllers objectAtIndex:0];
            userCenterVC.myBlock = ^(UIImage *image){
                cell.iconIV.image = image;
            };
            [self presentViewController:userNavi animated:YES completion:nil];
        }else{//否则跳转至登录界面
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController] animated:YES completion:nil];
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                CollectionViewController *collectionVC = [CollectionViewController new];
                UINavigationController *collectNavi = [[UINavigationController alloc] initWithRootViewController:collectionVC];
                [self presentViewController:collectNavi animated:YES completion:nil];
            }
                break;
            case 3:
            {
                UINavigationController *navi = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
                [self presentViewController:navi animated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
        
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = kRGBA(255, 255, 255, 0.5);
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row > 0) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
}
#pragma mark - 生命周期 LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        _tableView.backgroundColor = [UIColor clearColor];
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"UserInfoCell"];
        
	}
	return _tableView;
}

- (NSArray *)dataList {
	if(_dataList == nil) {
        _dataList = @[@"我的收藏", @"我的足迹(开发中)", @"我的消息(开发中)", @"设置"];
	}
	return _dataList;
}

@end
