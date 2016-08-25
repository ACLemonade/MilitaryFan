//
//  VideoDetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/8/24.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "VideoDetailViewController.h"

#import "VideoDetailHeaderCell.h"
#import "ShareCell.h"
#include "MFVideoDetailViewModel.h"

#import <UIKit+AFNetworking.h>

@interface VideoDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSString *aid;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) MFVideoDetailViewModel *detailVM;
@end

@implementation VideoDetailViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        VideoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoDetailHeaderCell" forIndexPath:indexPath];
        [cell.iconIV setImageWithURL:self.detailVM.iconIV];
        cell.titleLb.text = self.detailVM.title;
        cell.pubDateLb.text = self.detailVM.pubDate;
        cell.authorLb.text = self.detailVM.author;
        cell.clickLb.text = self.detailVM.click;
    
        cell.zanLb.text = @"100";
        cell.caiLb.text = @"12";
        
        return cell;
    }
    if (indexPath.row == 1) {
        ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCell" forIndexPath:indexPath];
        return cell;
    }
    
    
    
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.detailVM getDataWithMode:0 completionHandle:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 懒加载 Lazy Load
- (instancetype)init{
    NSAssert(NO, @"必须使用initWithAid方法初始化, %s", __func__);
    return nil;
}
- (instancetype)initWithAid:(NSString *)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
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
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //cell不可被选中
        _tableView.allowsSelection = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"VideoDetailHeaderCell" bundle:nil] forCellReuseIdentifier:@"VideoDetailHeaderCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellReuseIdentifier:@"ShareCell"];
	}
	return _tableView;
}

- (MFVideoDetailViewModel *)detailVM {
	if(_detailVM == nil) {
        _detailVM = [[MFVideoDetailViewModel alloc] initWithAid:self.aid];
	}
	return _detailVM;
}

@end
