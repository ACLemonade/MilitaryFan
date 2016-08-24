//
//  LeftMenuViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataList;
@end

@implementation LeftMenuViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}


#pragma mark - 懒加载 Lazy Load
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(176);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
