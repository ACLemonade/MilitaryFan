//
//  MyAnswerViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "AnswerQuestionDetailViewController.h"
#import "MyAnswerViewModel.h"
#import "AnswerCell.h"

@interface MyAnswerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyAnswerViewModel *myAnswerVM;

@end

@implementation MyAnswerViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myAnswerVM.myAnswerNumber;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
    [cell.headIV setImageWithURL:[self.myAnswerVM answerHeadImageURLForSection:section] placeholderImage:kDefaultHeadImage];
    cell.answerNameLb.text = [self.myAnswerVM answerNameForForSection:section];
    cell.answerContentLb.text = [self.myAnswerVM answerContentForForSection:section];
    cell.adoptBtn.hidden = YES;
    cell.reportBtn.hidden = YES;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}
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
    NSInteger section = indexPath.section;
    AnswerQuestionDetailViewController *aqDetailVC = [[AnswerQuestionDetailViewController alloc] init];
    aqDetailVC.objectId = [self.myAnswerVM askIdForSection:section];
    [self.navigationController pushViewController:aqDetailVC animated:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    NSString *userName = [[NSDictionary dictionaryWithContentsOfFile:kUserPlistPath] objectForKey:@"userName"];
    [self.myAnswerVM getMyAnswerWithAnswerName:userName completionHandle:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _tableView.estimatedRowHeight = 145;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnswerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerCell class])];
    }
    return _tableView;
}
- (MyAnswerViewModel *)myAnswerVM{
    if (_myAnswerVM == nil) {
        _myAnswerVM = [[MyAnswerViewModel alloc] init];
    }
    return _myAnswerVM;
}
@end
