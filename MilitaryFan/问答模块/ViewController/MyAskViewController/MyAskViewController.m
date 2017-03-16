//
//  MyAskViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/16.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyAskViewController.h"
#import "AnswerQuestionDetailViewController.h"
#import "MyAskViewModel.h"
#import "QuestionCell.h"

@interface MyAskViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyAskViewModel *myAskVM;
@end

@implementation MyAskViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myAskVM.myQuestionNumber;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionCell class]) forIndexPath:indexPath];
    [cell.headIV setImageWithURL:[self.myAskVM headImageURLForSection:section] placeholderImage:kDefaultHeadImage];
    cell.contentLb.text = [self.myAskVM contentForSection:section];
    cell.resolvedStateLb.text = [self.myAskVM resolvedStateForSection:section];
    cell.answerNumberLb.text = [self.myAskVM answerNumberForSection:section];
    cell.createTimeLb.text = [self.myAskVM createTimeForSection:section];
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
    aqDetailVC.objectId = [self.myAskVM objectIdForSection:section];
    [self.navigationController pushViewController:aqDetailVC animated:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    NSString *userName = [[NSDictionary dictionaryWithContentsOfFile:kUserPlistPath] objectForKey:@"userName"];
    [self.myAskVM getMyQuestionWithAskName:userName completionHandle:^(NSError *error) {
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
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionCell class])];
        
    }
    return _tableView;
}
- (MyAskViewModel *)myAskVM{
    if (_myAskVM == nil) {
        _myAskVM = [[MyAskViewModel alloc] init];
    }
    return _myAskVM;
}
@end
