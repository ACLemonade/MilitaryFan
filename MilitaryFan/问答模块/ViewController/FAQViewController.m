//
//  FAQViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "FAQViewController.h"
#import "ChooseQuestionViewController.h"

@interface FAQViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
/** 问答搜索框 */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 最新问答列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 提问按钮 */
@property (nonatomic, strong) UIButton *askQuestionBtn;

@end

@implementation FAQViewController
#pragma mark - 协议方法 UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
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
- (void)askQuestion:(UIButton *)sender{
    ChooseQuestionViewController *chooseQuestionVC = [[ChooseQuestionViewController alloc] init];
    chooseQuestionVC.questionActionType = QuestionActionTypeAsk;
    [self.navigationController pushViewController:chooseQuestionVC animated:YES];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchBar];
    [self tableView];
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
            make.bottom.equalTo(self.askQuestionBtn.mas_top);
        }];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UIButton *)askQuestionBtn{
    if (_askQuestionBtn == nil) {
        _askQuestionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_askQuestionBtn];
        //位置,大小
        [_askQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
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
        //点击事件--提问
        [_askQuestionBtn addTarget:self action:@selector(askQuestion:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _askQuestionBtn;
}

@end
