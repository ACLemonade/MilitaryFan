//
//  AllCommentsViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 16/9/6.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "AllCommentsViewController.h"
#import "AllCommentsCell.h"

#import "AllCommentsViewModel.h"
#import "UIScrollView+Refresh.h"
@interface AllCommentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) AllCommentsViewModel *allCommentsVM;
@end

@implementation AllCommentsViewController
#pragma mark - 协议方法 UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCommentsVM.commentNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    AllCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCommentsCell"];
    cell.userNameLb.text = [self.allCommentsVM userNameForRow:row];
    cell.commentLb.text = [self.allCommentsVM commentForRow:row];
    cell.commentDateLb.text = [self.allCommentsVM createDateForRow:row];
    cell.commentLocationLb.text = [self.allCommentsVM userLocationForRow:row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.allCommentsVM commentHeightForRow:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
#pragma mark - 生命周期 LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self tableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefresh];
    }];
    [self.tableView beginHeaderRefresh];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView {
	if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AllCommentsCell" bundle:nil] forCellReuseIdentifier:@"AllCommentsCell"];
	}
	return _tableView;
}

- (AllCommentsViewModel *)allCommentsVM {
	if(_allCommentsVM == nil) {
		_allCommentsVM = [[AllCommentsViewModel alloc] init];
	}
	return _allCommentsVM;
}



@end
