//
//  ReportViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/4/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReportViewController.h"

#import "ReportViewModel.h"
#import "ReportNormalCell.h"
#import "ReportInputCell.h"
#import "SubmitCell.h"

@interface ReportViewController () <UITableViewDataSource, UITableViewDelegate, ReportInputCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReportViewModel *reportVM;
@end


@implementation ReportViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.reportVM.reportContentNumber;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == (self.reportVM.reportContentNumber - 1)) {
            ReportInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReportInputCell class]) forIndexPath:indexPath];
            cell.otherReportTV.text = [self.reportVM reportContentForRow:row];
            cell.selectBtn.tag = 1000 + row;
            [cell.selectBtn addTarget:self action:@selector(selectReport:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate = self;
            return cell;
        } else {
            ReportNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReportNormalCell class]) forIndexPath:indexPath];
            cell.normalReportLb.text = [self.reportVM reportContentForRow:row];
            cell.selectBtn.tag = 1000 + row;
            [cell.selectBtn addTarget:self action:@selector(selectReport:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    } else {
        SubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubmitCell class]) forIndexPath:indexPath];
        [cell.submitBtn setTitle:@"确认举报" forState:UIControlStateNormal];
        [cell.submitBtn addTarget:self action:@selector(submitReport:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 协议方法 ReportInputCellDelegate
- (void)reportInputCell:(ReportInputCell *)cell textViewDidEndEditing:(UITextView *)textView{
    [self.reportVM.reportContentArray replaceObjectAtIndex:3 withObject:textView.text];
}
#pragma mark - 方法 Methods
- (void)selectReport:(UIButton *)sender{
    sender.selected = !sender.selected;
    BOOL selectedState = sender.selected;
    NSInteger row = sender.tag - 1000;
    [self.reportVM.reportSelectedStateArray replaceObjectAtIndex:row withObject:@(selectedState)];
    if (row == 3) {
        ReportInputCell *cell = (ReportInputCell *)sender.superview.superview;
        if (selectedState) {
            cell.otherReportTV.userInteractionEnabled = YES;
            [cell.otherReportTV becomeFirstResponder];
            cell.otherReportTV.textColor = [UIColor blackColor];
        } else {
            cell.otherReportTV.userInteractionEnabled = NO;
            [cell.otherReportTV resignFirstResponder];
            cell.otherReportTV.textColor = [UIColor lightGrayColor];
        }
    }
}
- (void)submitReport:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSLog(@"确认举报");
    NSLog(@"%@", self.reportVM.reportSelectedStateArray);
    NSString *reportContent = @"";
    for (int i = 0; i < self.reportVM.reportContentNumber; i++) {
        BOOL selectedState = [[self.reportVM.reportSelectedStateArray objectAtIndex:i] boolValue];
        NSString *reportComponent = [self.reportVM.reportContentArray objectAtIndex:i];
        if (selectedState) {
            reportContent = [reportContent stringByAppendingString:reportComponent];
        } else {
            reportContent = [reportContent stringByAppendingString:@","];
        }
        if (i < self.reportVM.reportContentNumber - 1) {
            reportContent = [reportContent stringByAppendingString:@"///"];
        }
    }
    if ([reportContent isEqualToString:@"/////////"]) {
        [Factory textHUDWithVC:self text:@"请选择至少一条举报项"];
        sender.userInteractionEnabled = YES;
        return;
    }
    BmobObject *reportObj = [BmobObject objectWithClassName:@"Report"];
    [reportObj setObject:kUserName forKey:@"userName"];
    [reportObj setObject:self.reportedId forKey:@"reportedId"];
    [reportObj setObject:self.reportedName forKey:@"reportedName"];
    [reportObj setObject:reportContent forKey:@"reason"];
    [reportObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [Factory textHUDWithVC:self text:@"举报成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"error: %@", error);
        }
        sender.userInteractionEnabled = YES;
    }];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    self.navigationItem.title = @"举报";
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReportNormalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReportNormalCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReportInputCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReportInputCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubmitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SubmitCell class])];
    }
    return _tableView;
}
- (ReportViewModel *)reportVM{
    if (_reportVM == nil) {
        _reportVM = [[ReportViewModel alloc] init];
    }
    return _reportVM;
}
@end
