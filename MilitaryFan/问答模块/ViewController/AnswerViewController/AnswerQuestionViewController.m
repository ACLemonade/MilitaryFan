//
//  AnswerQuestionViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/8.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "QuestionCell.h"
#import "FAQViewModel.h"

#import "UIScrollView+Refresh.h"

@interface AnswerQuestionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** ViewModel数据项 */
@property (nonatomic, strong) FAQViewModel *faqVM;
@end

@implementation AnswerQuestionViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.faqVM.questionNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionCell class]) forIndexPath:indexPath];
    cell.contentLb.text = [self.faqVM contentForRow:row];
    [cell.headIV setImageWithURL:[self.faqVM headImageURLFor:row] placeholderImage:[UIImage imageNamed:@"Persn_login"]];
    cell.resolvedStateLb.text = [self.faqVM resolvedStateForRow:row];
    cell.answerNumberLb.text = [self.faqVM answerNumberForRow:row];
    cell.createTimeLb.text = [self.faqVM createTimeForRow:row];
    return cell;
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

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.faqVM getQuestionWithDetailType:weakSelf.detailType completionHandle:^(NSError *error) {
            if (!error) {
                [weakSelf.tableView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.tableView endHeaderRefresh];
        }];
    }];
    [self.tableView beginHeaderRefresh];
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
- (FAQViewModel *)faqVM{
    if (_faqVM == nil) {
        _faqVM = [[FAQViewModel alloc] init];
    }
    return _faqVM;
}
@end
