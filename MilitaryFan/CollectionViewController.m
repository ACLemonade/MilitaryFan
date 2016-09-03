//
//  CollectionViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "CollectionViewModel.h"
#import "NormalCell.h"

#import <UIKit+AFNetworking.h>
#import "UIScrollView+Refresh.h"

@interface CollectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) CollectionViewModel *collectionVM;
@end

@implementation CollectionViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
    return self.collectionVM.itemNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    NSInteger row = indexPath.row;
    [cell.iconIV setImageWithURL:[self.collectionVM iconURLForRow:row]];
    cell.titleLb.text = [self.collectionVM titleForRow:row];
    cell.pubDateLb.text = [self.collectionVM pubDateForRow:row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.aid = [self.collectionVM aidForRow:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
//左滑按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        FMDatabase *db = [FMDatabase databaseWithPath:kDataBasePath];
        if ([db open]) {
            BOOL suc = [db executeUpdate:@"delete from Collection where Aid = ?", [self.collectionVM aidForRow:indexPath.row]];
            if (suc) {
                NSLog(@"取消收藏成功!");
                [self.collectionVM collectionUpdate];
                [self.tableView reloadData];
            }
        }
        [db close];
    }];
    return @[deleteAction];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    [Factory nonNaviClickBackWithViewController:self];
    self.navigationItem.title = @"收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 懒加载 Lazy Load

- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"NormalCell"];
	}
	return _tableView;
}

- (CollectionViewModel *)collectionVM {
	if(_collectionVM == nil) {
		_collectionVM = [[CollectionViewModel alloc] init];
	}
	return _collectionVM;
}

@end
