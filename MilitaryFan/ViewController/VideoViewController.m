//
//  VideoViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/23.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "VideoViewController.h"
#import "MFVideoViewModel.h"
#import <UIKit+AFNetworking.h>
#import "UIScrollView+Refresh.h"
#import "TopCell.h"

@interface VideoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) MFVideoViewModel *videoVM;
@end

@implementation VideoViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoVM.itemNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    [cell.iconIV setImageWithURL:[self.videoVM iconURLForRow:row]];
    cell.titleLb.text = [self.videoVM titleForRow:row];
    cell.authorLb.text = [self.videoVM authorForRow:row];
    cell.pubDateLb.text = [self.videoVM pubDateForRow:row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 272;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.videoVM getDataWithMode:RequestRefresh completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
    }];
    [self.tableView addAutoFooterRefresh:^{
        [weakSelf.videoVM getDataWithMode:RequestGetMore completionHandle:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }else{
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView endFooterRefresh];
        }];
    }];
    [self.tableView beginHeaderRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载 Lazy Load
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:nil] forCellReuseIdentifier:@"TopCell"];
	}
	return _tableView;
}

- (MFVideoViewModel *)videoVM {
	if(_videoVM == nil) {
		_videoVM = [[MFVideoViewModel alloc] init];
	}
	return _videoVM;
}

@end
