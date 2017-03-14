//
//  AnswerQuestionDetailViewController.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/10.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AnswerQuestionDetailViewController.h"
#import "QuestionDetailCell.h"
#import "AnswerCell.h"
#import "AnswerQuestionDetailViewModel.h"

#import "AnswerView.h"

#define kViewBottomY (kScreenH - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT)
@interface AnswerQuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate, AnswerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnswerView *answerView;

@property (nonatomic, strong) AnswerQuestionDetailViewModel *aqDetailVM;
@end

@implementation AnswerQuestionDetailViewController
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.aqDetailVM.allAnswerNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        QuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionDetailCell class]) forIndexPath:indexPath];
        [cell.headIV setImageWithURL:self.aqDetailVM.headImageURL placeholderImage:kDefaultHeadImage];
        cell.askNameLb.text = self.aqDetailVM.askName;
        cell.contentLb.text = self.aqDetailVM.questionContent;
        cell.createTimeLb.text = self.aqDetailVM.createTime;
        return cell;
    } else {
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerCell class]) forIndexPath:indexPath];
        [cell.headIV setImageWithURL:[self.aqDetailVM answerHeadImageURLForRow:row] placeholderImage:kDefaultHeadImage];
        cell.answerNameLb.text = [self.aqDetailVM answerNameForRow:row];
        cell.answerContentLb.text = [self.aqDetailVM answerContentForRow:row];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
#pragma mark - 协议方法 AnswerViewDelegate
- (void)answerView:(AnswerView *)answerView contentViewDidChanged:(UITextView *)contentView{
    NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
    
    CGSize size = contentView.contentSize;
    CGRect frame = answerView.frame;
    if (size.height > 112) {
        return;
    }
    frame.origin.y = CGRectGetMaxY(frame) - (size.height + 10);
    frame.size.height = size.height + 10;
    [UIView animateWithDuration:0.25 animations:^{
        self.answerView.frame = frame;
        NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
        [self.answerView layoutIfNeeded];
    }];
}
#pragma mark - 方法 Methods
- (void)keyboardDidChanged:(NSNotification *)sender{
    NSLog(@"%@", sender.userInfo);
    CGRect rect = [[sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect frame = self.answerView.frame;
    frame.origin.y = rect.origin.y - frame.size.height - STATUSBAR_AND_NAVIGATIONBAR_HEIGHT;
    self.answerView.frame = frame;
    [self.answerView setNeedsDisplay];
}
- (void)sendAnswer:(UIButton *)sender{
    sender.enabled = NO;
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:kUserPlistPath];
    NSString *userName = [userDic objectForKey:@"userName"];
    BmobObject *obj = [BmobObject objectWithClassName:@"Answer"];
    [obj setObject:userName forKey:@"answerName"];
    [obj setObject:self.objectId forKey:@"askId"];
    [obj setObject:@(self.aqDetailVM.questionType) forKey:@"Type"];
    [obj setObject:self.answerView.contentView.text forKey:@"content"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        sender.enabled = YES;
        if (isSuccessful) {
            NSLog(@"回答成功");
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    [self answerView];
//    NSLog(@"viewFrame: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"frame: %@", NSStringFromCGRect(self.answerView.frame));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.aqDetailVM getQuestionDetailWithObjectId:self.objectId completionHandle:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    [self.aqDetailVM getAllAnswerWithoutHeadImageWithCompletionHandle:^(NSArray *array, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnswerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerCell class])];
    }
    return _tableView;
}
- (AnswerView *)answerView{
    if (_answerView == nil) {
        
        _answerView = [[AnswerView alloc] initWithFrame:CGRectMake(0, kViewBottomY - 46, kScreenW, 46)];
        [self.view addSubview:_answerView];
        _answerView.delegate = self;
        _answerView.backgroundColor = [UIColor whiteColor];
        [_answerView.sendBtn addTarget:self action:@selector(sendAnswer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerView;
}
- (AnswerQuestionDetailViewModel *)aqDetailVM{
    if (_aqDetailVM == nil) {
        _aqDetailVM = [[AnswerQuestionDetailViewModel alloc] init];
    }
    return _aqDetailVM;
}
@end
