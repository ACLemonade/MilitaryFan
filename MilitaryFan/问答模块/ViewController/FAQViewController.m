//
//  FAQViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "FAQViewController.h"
#import "ChooseQuestionViewController.h"
#import "FAQViewModel.h"
#import "QuestionCell.h"

#import "UIScrollView+Refresh.h"


@interface FAQViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
/** 问答搜索框 */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 最新问答列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 提问按钮 */
@property (nonatomic, strong) UIButton *askQuestionBtn;
/** 回答按钮 */
@property (nonatomic, strong) UIButton *answerQuestionBtn;
/** ViewModel数据项 */
@property (nonatomic, strong) FAQViewModel *faqVM;

@end

@implementation FAQViewController
#pragma mark - 协议方法 UITableViewDataSource/Delegate
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
#pragma mark - 方法 Methods
- (void)chooseQuestion:(UIButton *)sender{
    ChooseQuestionViewController *chooseQuestionVC = [[ChooseQuestionViewController alloc] init];
    chooseQuestionVC.questionActionType = sender.tag-100;
    [self.navigationController pushViewController:chooseQuestionVC animated:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchBar];
    WK(weakSelf);
    [self.tableView addHeaderRefresh:^{
        [weakSelf.faqVM getAllQuestionWithCompletionHandle:^(NSError *error) {
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
- (UISearchBar *)searchBar {
    if(_searchBar == nil) {
        //导航条的搜索条
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10.0f,0.0f,230.0f,44.0f)];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchBar.barTintColor = [UIColor blueColor];
        // 找到searchbar的searchField属性
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            // 设置字体颜色 & 占位符 (必须)
            searchField.textColor = [UIColor whiteColor];
            searchField.placeholder = @"placeholder";
            searchField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.3];
            // 根据@"_placeholderLabel.textColor" 找到placeholder的字体颜色
            [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
            // 圆角
            searchField.layer.cornerRadius = 13.0f;
            searchField.layer.masksToBounds = YES;
        }
        [_searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"cancel"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setPlaceholder:@"搜索问题"];
        self.navigationItem.titleView = _searchBar;
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.bottom.equalTo(self.answerQuestionBtn.mas_top);
        }];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionCell class])];
    }
    return _tableView;
}
- (UIButton *)askQuestionBtn{
    if (_askQuestionBtn == nil) {
        _askQuestionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_askQuestionBtn];
        //位置,大小
        [_askQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(0);
            make.width.equalTo(kScreenW/2-1);
            make.height.equalTo(40);
        }];
        //文本文字
        [_askQuestionBtn setTitle:@"我要提问" forState:UIControlStateNormal];
        //文本大小
        _askQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //文本颜色
        [_askQuestionBtn setTitleColor:kRGBA(63, 154, 253, 1) forState:UIControlStateNormal];
        //背景色
        _askQuestionBtn.backgroundColor = kRGBA(206, 224, 247, 1);
        //tag值
        _askQuestionBtn.tag = 100;
        //点击事件--提问
        [_askQuestionBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _askQuestionBtn;
}
- (UIButton *)answerQuestionBtn{
    if (_answerQuestionBtn == nil) {
        _answerQuestionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_answerQuestionBtn];
        //位置,大小
        [_answerQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(0);
            make.width.equalTo(self.askQuestionBtn);
            make.height.equalTo(self.askQuestionBtn);
        }];
        //文本文字
        [_answerQuestionBtn setTitle:@"我要回答" forState:UIControlStateNormal];
        //文本大小
        _answerQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //文本颜色
        [_answerQuestionBtn setTitleColor:kRGBA(63, 154, 253, 1) forState:UIControlStateNormal];
        //背景色
        _answerQuestionBtn.backgroundColor = kRGBA(206, 224, 247, 1);
        //tag值
        _answerQuestionBtn.tag = 101;
        //点击事件--回答
        [_answerQuestionBtn addTarget:self action:@selector(chooseQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerQuestionBtn;
}
- (FAQViewModel *)faqVM{
    if (_faqVM == nil) {
        _faqVM = [[FAQViewModel alloc] init];
    }
    return _faqVM;
}
@end
