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

@interface AnswerQuestionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** ViewModel数据项 */
@property (nonatomic, strong) FAQViewModel *faqVM;
@end

@implementation AnswerQuestionViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
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
