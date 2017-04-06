//
//  MyDetailInfoViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyDetailInfoViewController.h"
#import "MyDetailInfoViewModel.h"
#import "ReportNormalCell.h"
#import "ReportInputCell.h"

@interface MyDetailInfoViewController () <UITableViewDataSource, UITableViewDelegate, ReportInputCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyDetailInfoViewModel *myDetailInfoVM;
@end

@implementation MyDetailInfoViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myDetailInfoVM.reportContentNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == (self.myDetailInfoVM.reportContentNumber - 1)) {
        ReportInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReportInputCell class]) forIndexPath:indexPath];
        cell.otherReportTV.text = [self.myDetailInfoVM reportContentForRow:row];
        cell.delegate = self;
        return cell;
    }
    ReportNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReportNormalCell class]) forIndexPath:indexPath];
    cell.normalReportLb.text = [self.myDetailInfoVM reportContentForRow:row];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)reportInputCell:(ReportInputCell *)cell textViewDidChange:(UITextView *)textView{
    [self.myDetailInfoVM.reportContentArray replaceObjectAtIndex:3 withObject:textView.text];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [Factory naviClickBackWithViewController:self];
    [self tableView];
    NSLog(@"我的资料页");
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReportNormalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReportNormalCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReportInputCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReportInputCell class])];
    }
    return _tableView;
}
- (MyDetailInfoViewModel *)myDetailInfoVM{
    if (_myDetailInfoVM == nil) {
        _myDetailInfoVM = [[MyDetailInfoViewModel alloc] init];
    }
    return _myDetailInfoVM;
}
@end
